-- ~/.config/nvim/lua/codex/runner.lua
local M = {}

local codex_cli = require("codex.cli")
local uv = vim.uv or vim.loop
local ui = require("codex.ui")
local health = require("codex.health")

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

	log_event("fail", {
		op = op,
		stage = "preflight",
		reason = reason,
		message = "Codex blocked because healthcheck is not PASS",
	})

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

	local input = opts.input
	local op = opts.op or "codex_run"
	local spinner_message = opts.spinner_message or "Codex working…"

	-- Give immediate visual feedback as soon as a Codex action is invoked.
	-- Health checks and process startup can take long enough to feel like
	-- nothing happened, so the UX acknowledgement must happen first.
	ui.start(spinner_message)

	if opts._force_health_fail_for_test then
		block_for_health_failure(opts, "healthcheck_not_pass")
		return
	end

	local ok_health, healthy = pcall(health.is_healthy)
	if not ok_health or not healthy then
		block_for_health_failure(opts, ok_health and "healthcheck_not_pass" or "healthcheck_error")
		return
	end

	local prompt_text = opts.prompt
	if not prompt_text or prompt_text == "" then
		log_event("fail", {
			op = opts.op or "codex_run",
			stage = "codex_exec",
			reason = "missing_prompt",
		})

		ui.stop("Codex runner: missing prompt", vim.log.levels.ERROR)
		return
	end

	local out_stdout, out_stderr = {}, {}
	local started_ns = uv.hrtime()
	local first_stdout_seen = false
	local first_stderr_seen = false

	local function elapsed_ms()
		return hrtime_ms(started_ns)
	end

	local function log_latency_phase(stage, extra)
		log_event(
			"latency",
			vim.tbl_extend("force", {
				op = op,
				stage = stage,
				elapsed_ms = elapsed_ms(),
				filetype = opts.filetype,
			}, extra or {})
		)
	end

	log_event("start", {
		op = op,
		prompt_len = #prompt_text,
		input_len = input and #input or 0,
		filetype = opts.filetype,
		embedded = opts.embedded or false,
	})

	local argv = codex_cli.build_exec_argv(prompt_text)

	local job_id = vim.fn.jobstart(argv, {
		pty = opts.pty or false,
		env = opts.env,
		stdout_buffered = false,
		stderr_buffered = false,

		on_stdout = function(_, data)
			if data then
				vim.list_extend(out_stdout, data)
				if not first_stdout_seen then
					for _, line in ipairs(data) do
						if line and line ~= "" then
							first_stdout_seen = true
							log_latency_phase("first_stdout", {
								result = "INFO",
								bytes = #line,
							})
							break
						end
					end
				end
			end
		end,

		on_stderr = function(_, data)
			if data then
				vim.list_extend(out_stderr, data)
				if not first_stderr_seen then
					for _, line in ipairs(data) do
						if line and line ~= "" then
							first_stderr_seen = true
							log_latency_phase("first_stderr", {
								result = "INFO",
								bytes = #line,
							})
							break
						end
					end
				end
			end
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
					ui.stop("Codex failed (see output)", vim.log.levels.ERROR)

					log_event("fail", {
						op = op,
						stage = "codex_exec",
						code = code,
						latency_ms = latency_ms,
						stdout_lines = #stdout,
						stderr_lines = #stderr,
					})

					log_event("latency", {
						op = op,
						stage = "codex_exec",
						elapsed_ms = latency_ms,
						result = "FAIL",
						filetype = opts.filetype,
					})

					if opts.on_failure then
						opts.on_failure(result)
					end
					return
				end

				ui.stop("Codex done", vim.log.levels.INFO)

				log_event("response", {
					op = op,
					bytes = #table.concat(result.output, "\n"),
				})

				log_event("latency", {
					op = op,
					stage = "codex_exec",
					elapsed_ms = latency_ms,
					result = "PASS",
					filetype = opts.filetype,
				})

				if opts.on_success then
					opts.on_success(result)
				end
			end)
		end,
	})

	if job_id <= 0 then
		ui.stop("Failed to start Codex job", vim.log.levels.ERROR)

		log_event("fail", {
			op = op,
			stage = "codex_exec",
			reason = "jobstart_failed",
			result = tostring(job_id),
			prompt_len = #prompt_text,
			input_len = input and #input or 0,
		})

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
