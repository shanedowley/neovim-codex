-- ~/.config/nvim/lua/codex/runner.lua
local M = {}

local codex_cli = require("codex.cli")
local uv = vim.uv or vim.loop
local ui = require("codex.ui")
local health = require("codex.health")
local output = require("codex.output")

local health_cache = {
	ok = false,
	checked_at = nil,
	running = false,
	result = nil,
}

local request_counter = 0

local function next_request_id()
	request_counter = request_counter + 1
	return string.format("req-%06d", request_counter)
end

local function log_event(event, data)
	local ok, codex_log = pcall(require, "codex_log")
	if not ok or type(codex_log) ~= "table" then
		return
	end

	if type(codex_log.event) == "function" then
		pcall(codex_log.event, event, data)
	elseif type(codex_log.write) == "function" then
		pcall(codex_log.write, event, data)
	elseif type(codex_log.append) == "function" then
		pcall(codex_log.append, {
			event = event,
			data = data,
			ts = os.date("!%Y-%m-%dT%H:%M:%SZ"),
		})
	end
end

local function with_request(opts, data)
	data = data or {}
	data.request_id = opts.request_id
	return data
end

local function hrtime_ms(start_ns)
	return math.floor((uv.hrtime() - start_ns) / 1e6)
end

local function normalize_lines(lines)
	local out = {}
	for _, l in ipairs(lines or {}) do
		if l ~= nil then
			out[#out + 1] = (l:gsub("\r", ""))
		end
	end
	return out
end

local function fence_lang(filetype)
	local ok, prompt = pcall(require, "codex_prompt")
	if ok and type(prompt) == "table" and type(prompt.fence_lang) == "function" then
		return prompt.fence_lang(filetype or "")
	end
	return filetype or ""
end

local function block_for_health_failure(opts, reason)
	local op = opts.op or "codex_run"

	log_event(
		"fail",
		with_request(opts, {
			op = op,
			stage = "preflight",
			reason = reason,
			message = "Codex blocked because healthcheck is not PASS",
		})
	)

	pcall(function()
		require("codex_recovery").capture({
			kind = reason,
			stage = "preflight",
			op = op,
			mode = nil,
			file = nil,
			reason = "Codex blocked because healthcheck is not PASS",
			title = "Codex Blocked",
			lines = {
				"Codex runner refused to execute.",
				"",
				"Reason: " .. (reason == "healthcheck_error" and "healthcheck errored." or "healthcheck is not PASS."),
				"Run :CodexHealth for full diagnostics.",
			},
		})
	end)

	ui.stop("Codex blocked: healthcheck is not PASS", vim.log.levels.ERROR)
end

function M.run(opts)
	opts = opts or {}

	local request_id = next_request_id()
	opts.request_id = request_id

	local input = opts.input
	local op = opts.op or "codex_run"
	local spinner_message = opts.spinner_message or "Codex working…"

	local stream_output = opts.stream_output == true
	local stream_bufnr = nil

	-- Immediate UX acknowledgement.
	ui.start(spinner_message)

	if stream_output then
		vim.schedule(function()
			stream_bufnr = output.open({
				title = "Codex " .. op,
				filetype = "markdown",
			})
		end)
	end

	-- Yield once so Neovim can render the notification/output buffer before
	-- synchronous preflight checks and job startup begin.
	vim.schedule(function()
		if opts._force_health_fail_for_test then
			block_for_health_failure(opts, "healthcheck_not_pass")
			if stream_output and stream_bufnr then
				output.fail(stream_bufnr, { "Codex blocked: healthcheck is not PASS." })
			end
			return
		end

		local ok_health, healthy

		if health_cache.ok then
			ok_health = true
			healthy = true

			log_event(
				"latency",
				with_request(opts, {
					op = op,
					stage = "healthcheck_cached",
					elapsed_ms = 0,
					result = "PASS",
				})
			)
		else
			local health_started_ns = uv.hrtime()
			ok_health, healthy = pcall(health.is_runnable)

			log_event(
				"latency",
				with_request(opts, {
					op = op,
					stage = "healthcheck",
					elapsed_ms = hrtime_ms(health_started_ns),
					result = (ok_health and healthy) and "PASS" or "FAIL",
				})
			)

			if ok_health and healthy then
				health_cache.ok = true
				health_cache.checked_at = os.time()
			end
		end

		if not ok_health or not healthy then
			local reason = ok_health and "healthcheck_not_pass" or "healthcheck_error"
			block_for_health_failure(opts, reason)

			if stream_output and stream_bufnr then
				output.fail(stream_bufnr, {
					"Codex blocked before execution.",
					"",
					"Reason: " .. reason,
					"",
					"Run :CodexHealth for diagnostics.",
				})
			end

			return
		end

		local prompt_text = opts.prompt
		if not prompt_text or prompt_text == "" then
			log_event(
				"fail",
				with_request(opts, {
					op = opts.op or "codex_run",
					stage = "codex_exec",
					reason = "missing_prompt",
				})
			)

			ui.stop("Codex runner: missing prompt", vim.log.levels.ERROR)
			return
		end

		local out_stdout, out_stderr = {}, {}
		local first_stdout_seen = false
		local first_stderr_seen = false
		local started_ns = uv.hrtime()
		local stream_seen_assistant = false

		log_event(
			"start",
			with_request(opts, {
				op = op,
				prompt_len = #prompt_text,
				input_len = input and #input or 0,
				filetype = opts.filetype,
				embedded = opts.embedded or false,
			})
		)

		local argv = codex_cli.build_exec_argv(prompt_text)
		local job_id = vim.fn.jobstart(argv, {
			pty = opts.pty or false,
			env = opts.env,
			stdout_buffered = false,
			stderr_buffered = false,

			on_stdout = function(_, data)
				if not data then
					return
				end

				vim.list_extend(out_stdout, data)

				local lines = normalize_lines(data)
				if #lines == 0 then
					return
				end

				local elapsed = hrtime_ms(started_ns)

				if not first_stdout_seen then
					first_stdout_seen = true
					log_event(
						"latency",
						with_request(opts, {
							op = op,
							stage = "first_stdout",
							elapsed_ms = elapsed,
						})
					)
				end

				log_event(
					"stdout_chunk",
					with_request(opts, {
						op = op,
						lines = #lines,
						bytes = #table.concat(lines, "\n"),
						elapsed_ms = elapsed,
					})
				)

				if stream_output then
					local visible = {}

					for _, line in ipairs(lines) do
						if line == "codex" then
							stream_seen_assistant = true
						elseif line == "tokens used" then
							stream_seen_assistant = false
						elseif stream_seen_assistant then
							visible[#visible + 1] = line
						end
					end

					if #visible > 0 then
						vim.schedule(function()
							if not stream_bufnr then
								stream_bufnr = output.open({
									title = "Codex " .. op,
									filetype = "markdown",
								})
							end
							output.append(stream_bufnr, visible)
						end)
					end
				end
			end,

			on_stderr = function(_, data)
				if not data then
					return
				end

				vim.list_extend(out_stderr, data)

				local lines = normalize_lines(data)
				if #lines == 0 then
					return
				end

				local elapsed = hrtime_ms(started_ns)

				if not first_stderr_seen then
					first_stderr_seen = true
					log_event(
						"latency",
						with_request(opts, {
							op = op,
							stage = "first_stderr",
							elapsed_ms = elapsed,
						})
					)
				end

				log_event(
					"stderr_chunk",
					with_request(opts, {
						op = op,
						lines = #lines,
						bytes = #table.concat(lines, "\n"),
						elapsed_ms = elapsed,
					})
				)
			end,

			on_exit = function(_, code)
				vim.schedule(function()
					local latency_ms = hrtime_ms(started_ns)
					local stdout = normalize_lines(out_stdout)
					local stderr = normalize_lines(out_stderr)

					local result = {
						code = code,
						stdout = stdout,
						stderr = stderr,
						output = (#stdout > 0) and stdout or stderr,
						latency_ms = latency_ms,
						op = op,
					}

					if code ~= 0 then
						ui.stop("Codex failed (see recovery report)", vim.log.levels.ERROR)

						log_event(
							"fail",
							with_request(opts, {
								op = op,
								stage = "codex_exec",
								code = code,
								latency_ms = latency_ms,
								stdout_lines = #stdout,
								stderr_lines = #stderr,
							})
						)

						log_event(
							"latency",
							with_request(opts, {
								op = op,
								stage = "codex_exec",
								elapsed_ms = latency_ms,
								result = "FAIL",
								filetype = opts.filetype,
							})
						)

						if stream_output and stream_bufnr then
							output.fail(stream_bufnr, result.output)
						end

						pcall(function()
							require("codex_recovery").show_failure({
								kind = "codex_exec_failed",
								stage = "codex_exec",
								op = op,
								request_id = opts.request_id,
								latency_ms = latency_ms,
								exit_code = code,
								filetype = opts.filetype,
								reason = "Codex execution failed",
								stdout = stdout,
								stderr = stderr,
								lines = result.output,
								title = "Codex Recovery Report",
							})
						end)

						if opts.on_failure then
							opts.on_failure(result)
						end

						return
					end

					ui.stop("Codex done", vim.log.levels.INFO)

					log_event(
						"response",
						with_request(opts, {
							op = op,
							bytes = #table.concat(result.output, "\n"),
						})
					)

					log_event(
						"latency",
						with_request(opts, {
							op = op,
							stage = "codex_exec",
							elapsed_ms = latency_ms,
							result = "PASS",
							filetype = opts.filetype,
						})
					)

					if stream_output and stream_bufnr then
						output.finish(stream_bufnr)
					end

					if opts.on_success then
						opts.on_success(result)
					end
				end)
			end,
		})

		if job_id <= 0 then
			ui.stop("Failed to start Codex job", vim.log.levels.ERROR)

			log_event(
				"fail",
				with_request(opts, {
					op = op,
					stage = "codex_exec",
					reason = "jobstart_failed",
					result = tostring(job_id),
					prompt_len = #prompt_text,
					input_len = input and #input or 0,
				})
			)

			if stream_output and stream_bufnr then
				output.fail(stream_bufnr, { "Failed to start Codex job." })
			end

			if opts.on_failure then
				opts.on_failure({
					code = -1,
					stdout = {},
					stderr = {},
					output = {},
					latency_ms = 0,
					op = op,
				})
			end

			return
		end

		if input and input ~= "" then
			vim.fn.chansend(job_id, input .. "\n")
		end

		vim.fn.chanclose(job_id, "stdin")
	end)
end

function M.warm_health_cache()
	if health_cache.ok or health_cache.running then
		return
	end

	health_cache.running = true

	vim.defer_fn(function()
		local started_ns = uv.hrtime()

		log_event("health_warmup_start", {
			op = "health_warmup",
			stage = "healthcheck_async",
		})

		local cmd = {
			"nvim",
			"--headless",
			"+lua local ok = require('codex.health').is_runnable(); vim.cmd(ok and 'cquit 0' or 'cquit 1')",
		}

		vim.system(cmd, { text = true }, function(result)
			vim.schedule(function()
				local ok = result.code == 0

				health_cache.running = false
				health_cache.result = ok

				log_event("latency", {
					op = "health_warmup",
					stage = "healthcheck_async",
					elapsed_ms = hrtime_ms(started_ns),
					result = ok and "PASS" or "FAIL",
				})

				if ok then
					health_cache.ok = true
					health_cache.checked_at = os.time()
				else
					health_cache.ok = false
				end
			end)
		end)
	end, 1500)
end

function M.run_embedded(input, instruction, opts)
	opts = opts or {}

	local lang = fence_lang(opts.filetype)
	local prompt_text = instruction .. "\n\n---\nHere is the code/snippet:\n```" .. lang .. "\n" .. input .. "\n```"

	local env = opts.env
		or {
			PAGER = "cat",
			GIT_PAGER = "cat",
			LESS = "-FRSX",
			NO_COLOR = "1",
			TERM = "xterm-256color",
		}

	M.run(vim.tbl_extend("force", opts, {
		prompt = prompt_text,
		input = nil,
		pty = true,
		env = env,
		embedded = true,
	}))
end

return M
