local M = {} -- module table

local codex_cli = require("codex.cli") -- Load the Codex CLI helpers used by this module

local codex_config = require("codex.config")
M._force_fail_for_test = false

M._cache = nil
M._cache_time = nil
M._cache_ttl_ms = 300000 -- 5 minutes

local function expand(path)
	return vim.fn.expand(path)
end

local function path_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function is_readable(path)
	return vim.fn.filereadable(path) == 1
end

local function is_dir(path)
	local stat = vim.uv.fs_stat(path)
	return stat and stat.type == "directory" or false
end

local function add_result(results, name, status, detail)
	results[#results + 1] = {
		name = name,
		status = status,
		detail = detail or "",
	}
end

local function overall_status(results)
	local has_degraded = false
	local has_warn = false

	for _, item in ipairs(results) do
		if item.status == "FAIL" then
			return "FAIL"
		end
		if item.status == "DEGRADED" then
			has_degraded = true
		end
		if item.status == "WARN" then
			has_warn = true
		end
	end

	if has_degraded or has_warn then
		return "DEGRADED"
	end

	return "PASS"
end

local function now_ms()
	return math.floor(vim.uv.hrtime() / 1e6)
end

local function cache_valid()
	if not M._cache or not M._cache_time then
		return false
	end

	return (now_ms() - M._cache_time) < M._cache_ttl_ms
end

local function set_cache(results)
	M._cache = results
	M._cache_time = now_ms()
end

local function clear_cache()
	M._cache = nil
	M._cache_time = nil
end

local function count_statuses(results)
	local counts = {
		PASS = 0,
		DEGRADED = 0,
		WARN = 0,
		FAIL = 0,
	}

	for _, item in ipairs(results) do
		if counts[item.status] ~= nil then
			counts[item.status] = counts[item.status] + 1
		end
	end

	return counts
end

local function check_executable(results, exe, required)
	if vim.fn.executable(exe) == 1 then
		add_result(results, "executable: " .. exe, "PASS", "found in PATH")
	else
		add_result(results, "executable: " .. exe, required and "FAIL" or "WARN", "not found in PATH")
	end
end

local function command_output(cmd)
	local out = vim.fn.system(cmd)
	local code = vim.v.shell_error

	if code ~= 0 then
		return nil, code
	end

	out = vim.trim(out or "")
	return out, 0
end

local function first_line(text)
	if not text or text == "" then
		return ""
	end

	return vim.split(text, "\n", { plain = true })[1] or text
end

local function parse_semver(v)
	local major, minor, patch = v:match("(%d+)%.(%d+)%.(%d+)")
	return tonumber(major), tonumber(minor), tonumber(patch)
end

local function is_version_at_least(current, required)
	local cmaj, cmin, cpat = parse_semver(current)
	local rmaj, rmin, rpat = parse_semver(required)

	if not cmaj then
		return false
	end

	if cmaj > rmaj then
		return true
	end
	if cmaj < rmaj then
		return false
	end

	if cmin > rmin then
		return true
	end
	if cmin < rmin then
		return false
	end

	return cpat >= rpat
end

local function check_codex_version(results)
	local out, code = command_output({ "codex", "--version" })

	if not out then
		add_result(results, "version: codex", "FAIL", "unable to detect version")
		return
	end

	local version = out:match("(%d+%.%d+%.%d+)")
	if not version then
		add_result(results, "version: codex", "FAIL", "unparseable version: " .. out)
		return
	end

	local required = codex_config.get().health.min_cli_version

	if is_version_at_least(version, required) then
		add_result(results, "version: codex", "PASS", version)
	else
		add_result(results, "version: codex", "FAIL", "too old: " .. version .. " (need >= " .. required .. ")")
	end
end

local function check_codex_model(results)
	local config = codex_config.get()

	if not config.health.model_probe_enabled then
		add_result(results, "codex model exec", "WARN", "model probe disabled")
		return
	end

	local argv = codex_cli.build_exec_argv("Say PASS only.")

	local out, code = command_output(argv)

	if not out then
		add_result(results, "codex model exec", "FAIL", "execution failed")
		return
	end

	if out:match("PASS") then
		add_result(results, "codex model exec", "PASS", config.model .. " OK")
	else
		add_result(results, "codex model exec", "FAIL", "unexpected output")
	end
end

local function check_command_version(results, name, cmd, required)
	if vim.fn.executable(cmd[1]) ~= 1 then
		add_result(results, "version: " .. name, required and "FAIL" or "DEGRADED", "executable not found")
		return
	end

	local out, code = command_output(cmd)
	if not out then
		add_result(
			results,
			"version: " .. name,
			required and "FAIL" or "DEGRADED",
			"command failed with exit code " .. tostring(code)
		)
		return
	end

	add_result(results, "version: " .. name, "PASS", first_line(out))
end

local function check_module(results, modname, required)
	local ok, loaded = pcall(require, modname)
	if ok and loaded then
		add_result(results, "module: " .. modname, "PASS", "loaded successfully")
	else
		add_result(results, "module: " .. modname, required and "FAIL" or "WARN", "failed to load")
	end
end

local function check_prompt_files(results)
	local prompt_dir = expand(vim.fn.stdpath("config") .. "/codex/prompts")

	if is_dir(prompt_dir) then
		add_result(results, "prompt dir", "PASS", prompt_dir)
	else
		add_result(results, "prompt dir", "WARN", "missing: " .. prompt_dir)
	end

	local required_files = {
		"raw_rewrite.md",
		"apply.md",
	}

	for _, filename in ipairs(required_files) do
		local path = prompt_dir .. "/" .. filename
		if is_readable(path) then
			add_result(results, "prompt file: " .. filename, "PASS", "readable")
		else
			add_result(results, "prompt file: " .. filename, "WARN", "missing/unreadable; fallback should apply")
		end
	end

	local explain_candidates = {
		"explain.md",
		"explain_c.md",
	}

	local found = nil
	for _, filename in ipairs(explain_candidates) do
		local path = prompt_dir .. "/" .. filename
		if is_readable(path) then
			found = filename
			break
		end
	end

	if found then
		add_result(results, "prompt file: explain", "PASS", "using " .. found)
	else
		add_result(
			results,
			"prompt file: explain",
			"WARN",
			"missing/unreadable; checked explain.md and explain_c.md; fallback should apply"
		)
	end
end

local function check_prompt_resolution(results)
	local ok, prompt_mod = pcall(require, "codex_prompt")
	if not ok or not prompt_mod then
		add_result(results, "prompt builders", "FAIL", "codex_prompt unavailable")
		return
	end

	local function check_builder(name, fn)
		local ok_call, value = pcall(fn)
		if ok_call and type(value) == "string" and value ~= "" then
			add_result(results, "prompt build: " .. name, "PASS", "builder returned text")
		elseif not ok_call then
			add_result(results, "prompt build: " .. name, "WARN", "builder raised an error")
		else
			add_result(results, "prompt build: " .. name, "WARN", "builder returned empty/unusable text")
		end
	end

	check_builder("raw_rewrite", function()
		return prompt_mod.build_raw_rewrite("test instruction", "c", 1)
	end)

	check_builder("apply", function()
		return prompt_mod.build_apply("test instruction", "int x = 1;")
	end)

	check_builder("explain", function()
		return prompt_mod.build_explain("c")
	end)
end

local function ensure_parent_dir(path)
	local dir = vim.fn.fnamemodify(path, ":h")

	if path_exists(dir) then
		return true, dir
	end

	local ok = vim.fn.mkdir(dir, "p")
	if ok == 1 or path_exists(dir) then
		return true, dir
	end

	return false, dir
end

local function check_log_path(results)
	local log_path = expand(vim.fn.stdpath("state") .. "/codex.log")
	local ok_dir, dir = ensure_parent_dir(log_path)

	if not ok_dir then
		add_result(results, "log dir", "WARN", "could not create: " .. dir)
		add_result(results, "log file", "WARN", "directory unavailable: " .. log_path)
		return
	end

	add_result(results, "log dir", "PASS", dir)

	local fd = vim.uv.fs_open(log_path, "a", 420) -- 0644
	if not fd then
		add_result(results, "log file", "WARN", "not writable: " .. log_path)
		return
	end

	vim.uv.fs_close(fd)
	add_result(results, "log file", "PASS", log_path)
end

local function check_xdg_layout(results)
	local config = vim.fn.stdpath("config")
	local data = vim.fn.stdpath("data")

	local bad_paths = {
		config .. "/lazy",
		config .. "/nvim",
		config .. "/tmp",
		config .. "/gem",
	}

	for _, path in ipairs(bad_paths) do
		if path_exists(path) then
			add_result(results, "xdg violation: " .. path, "FAIL", "should not exist in config")
		else
			add_result(results, "xdg clean: " .. path, "PASS", "not present")
		end
	end

	local lazy_path = data .. "/lazy/lazy.nvim"

	if path_exists(lazy_path) then
		add_result(results, "lazy install", "PASS", lazy_path)
	else
		add_result(results, "lazy install", "FAIL", "missing: " .. lazy_path)
	end
end

local function count_dirs(path)
	local fs = vim.uv.fs_scandir(path)
	if not fs then
		return 0
	end

	local count = 0
	while true do
		local name, typ = vim.uv.fs_scandir_next(fs)
		if not name then
			break
		end
		if typ == "directory" then
			count = count + 1
		end
	end

	return count
end

local function check_lazy_integrity(results)
	local data = vim.fn.stdpath("data")
	local lazy_root = data .. "/lazy"
	local lazy_nvim = lazy_root .. "/lazy.nvim"

	if not is_dir(lazy_root) then
		add_result(results, "lazy root", "FAIL", "missing: " .. lazy_root)
		return
	end

	add_result(results, "lazy root", "PASS", lazy_root)

	if not is_dir(lazy_nvim) then
		add_result(results, "lazy.nvim directory", "FAIL", "missing: " .. lazy_nvim)
	else
		add_result(results, "lazy.nvim directory", "PASS", lazy_nvim)
	end

	local plugin_count = count_dirs(lazy_root)

	if plugin_count < 10 then
		add_result(results, "plugin install count", "FAIL", "only " .. plugin_count .. " plugin dirs found")
	else
		add_result(results, "plugin install count", "PASS", tostring(plugin_count) .. " plugin dirs found")
	end
end

function M.run_checks()
	local results = {}

	-- Hard dependencies
	check_codex_version(results)
	check_codex_model(results)

	check_executable(results, "codex", true)
	check_executable(results, "clang", true)
	check_executable(results, "git", true)
	check_executable(results, "diff", true)

	-- Tool versions
	check_command_version(results, "clang", { "clang", "--version" }, true)
	check_command_version(results, "git", { "git", "--version" }, true)
	check_command_version(results, "diff", { "diff", "--version" }, true)

	-- Core modules
	check_module(results, "codex_cli", true)
	check_module(results, "codex.runner", true)
	check_module(results, "codex.preview", true)
	check_module(results, "codex.prompt_store", true)
	check_module(results, "codex_guard", true)
	check_module(results, "codex.clang", true)
	check_module(results, "codex_log", true)
	check_module(results, "codex_prompt", true)
	check_module(results, "codex.config", true)
	check_module(results, "codex.cli", true)
	check_module(results, "codex.failure", true)
	check_module(results, "codex.latency", true)

	-- Optional JavaScript debug/build capability
	check_command_version(results, "node", { "node", "--version" }, false)
	check_command_version(results, "npm", { "npm", "--version" }, false)

	-- XDG layout validation
	check_xdg_layout(results)

	-- Lazy/plugin integrity
	check_lazy_integrity(results)

	-- Prompt system
	check_prompt_files(results)
	check_prompt_resolution(results)

	-- Observability path
	check_log_path(results)

	return results
end

function M.summary_status(results)
	return overall_status(results)
end

function M.is_healthy()
	if M._force_fail_for_test then
		return false
	end

	if cache_valid() then
		return overall_status(M._cache) == "PASS"
	end

	local results = M.run_checks()
	local status = overall_status(results)

	if status == "PASS" then
		set_cache(results)
	else
		clear_cache()
	end

	return status == "PASS"
end

function M.status(force_refresh)
	if force_refresh then
		clear_cache()
	end

	local results = M.run_checks()
	local status = overall_status(results)

	if status == "PASS" then
		set_cache(results)
	else
		clear_cache()
	end

	return status, results
end

local function render_report(results)
	local counts = count_statuses(results)
	local overall = overall_status(results)

	local lines = {
		"Codex Health Check",
		"==================",
		"",
		"Overall: " .. overall,
		string.format(
			"PASS: %d   DEGRADED: %d   WARN: %d   FAIL: %d",
			counts.PASS,
			counts.DEGRADED,
			counts.WARN,
			counts.FAIL
		),
		"",
	}

	for _, item in ipairs(results) do
		lines[#lines + 1] = string.format("[%s] %s", item.status, item.name)
		if item.detail and item.detail ~= "" then
			lines[#lines + 1] = "  " .. item.detail
		end
	end

	return lines
end

local function open_report_buffer(lines)
	local buf = vim.api.nvim_create_buf(false, true)
	if not buf then
		vim.notify("Codex health: failed to create report buffer", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "markdown"

	vim.cmd("botright new")
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_name(buf, "codex://health")
end

function M.show()
	local results = M.run_checks()
	local overall = overall_status(results)
	local counts = count_statuses(results)

	local level = vim.log.levels.INFO
	if overall == "DEGRADED" then
		level = vim.log.levels.WARN
	elseif overall == "FAIL" then
		level = vim.log.levels.ERROR
	end

	local summary = string.format(
		"Codex health: %s (%d pass, %d degraded, %d warn, %d fail)",
		overall,
		counts.PASS,
		counts.DEGRADED,
		counts.WARN,
		counts.FAIL
	)

	vim.notify(summary, level, { title = "Codex" })
	open_report_buffer(render_report(results))

	return results
end

function M.check()
	local health = vim.health

	health.start("codex")

	local results = M.run_checks()
	for _, item in ipairs(results) do
		local message = item.name
		if item.detail and item.detail ~= "" then
			message = message .. ": " .. item.detail
		end

		if item.status == "PASS" then
			health.ok(message)
		elseif item.status == "DEGRADED" or item.status == "WARN" then
			health.warn(message)
		elseif item.status == "FAIL" then
			health.error(message)
		end
	end
end

return M
