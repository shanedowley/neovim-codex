local M = {}

local window = require("codex.window")

local LOG_SCHEMA_VERSION = "r1.2-v1"

local session_id = tostring(os.time()) .. "-" .. tostring(math.random(1000, 9999))

local function log_path()
	return vim.fn.stdpath("state") .. "/codex.log" -- build the Codex log path inside Neovim's state directory
end

local function timestamp()
	return os.date("%Y-%m-%d %H:%M:%S")
end

local function serialize(data)
	if not data then
		return ""
	end

	local preferred_order = {
		"session_id",
		"log_schema",
		"request_id",
		"op",
		"stage",
		"result",
		"elapsed_ms",
		"latency_ms",
		"filetype",
		"embedded",
		"mode",
		"file",
		"range",
		"check",
		"classification",
		"prompt_len",
		"input_len",
		"bytes",
		"lines",
		"code",
		"stdout_lines",
		"stderr_lines",
		"reason",
		"message",
	}

	local parts = {}
	local seen = {}

	local function add_field(key)
		local value = data[key]

		if value == nil then
			return
		end

		seen[key] = true

		value = tostring(value):gsub("\n", "\\n"):gsub(" | ", " / ")

		table.insert(parts, string.format("%s=%s", key, value))
	end

	-- Stable canonical ordering first.
	for _, key in ipairs(preferred_order) do
		add_field(key)
	end

	-- Append any remaining fields alphabetically.
	local remaining = {}

	for key, _ in pairs(data) do
		if not seen[key] then
			table.insert(remaining, key)
		end
	end

	table.sort(remaining)

	for _, key in ipairs(remaining) do
		add_field(key)
	end

	return table.concat(parts, " | ")
end

function M.path()
	return log_path()
end

function M.write(event, data)
	data = data or {}
	data.session_id = session_id
	data.log_schema = LOG_SCHEMA_VERSION

	local line = string.format("[%s] event=%s", timestamp(), event)

	local extra = serialize(data)
	if extra ~= "" then
		line = line .. " | " .. extra
	end

	line = line .. "\n"

	local ok, err = pcall(function()
		local f = assert(io.open(log_path(), "a"))
		f:write(line)
		f:close()
	end)

	if not ok then
		vim.schedule(function()
			vim.notify("Codex log write failed: " .. tostring(err), vim.log.levels.WARN)
		end)
	end
end

function M.clear()
	local ok, err = pcall(function()
		local f = assert(io.open(log_path(), "w"))
		f:write("")
		f:close()
	end)

	if not ok then
		vim.schedule(function()
			vim.notify("Codex log clear failed: " .. tostring(err), vim.log.levels.WARN)
		end)
	end
end

local function format_log_line(line)
	local timestamp = line:match("^%[(.-)%]")
	local body = line:gsub("^%[.-%]%s*", "")

	local fields = vim.split(body, " | ", { plain = true })
	local out = {}

	if timestamp then
		table.insert(out, "[" .. timestamp .. "]")
	end

	for i, field in ipairs(fields) do
		if i == 1 then
			table.insert(out, field)
		else
			table.insert(out, "| " .. field)
		end
	end

	table.insert(out, "")

	return out
end

function M.open_log()
	local path = log_path()
	local bufname = "codex-log://formatted"

	local raw = {}
	if vim.fn.filereadable(path) == 1 then
		raw = vim.fn.readfile(path)
	end

	local session_raw = {}

	for _, line in ipairs(raw) do
		if line:find("session_id=" .. session_id, 1, true) then
			table.insert(session_raw, line)
		end
	end

	raw = session_raw

	local lines = {}
	for _, line in ipairs(raw) do
		vim.list_extend(lines, format_log_line(line))
	end

	if #lines == 0 then
		lines = { "Codex log is empty for this Neovim session." }
	end

	local bufnr = window.open({
		name = bufname,
		lines = lines,
		filetype = "text",
		close_desc = "Close Codex log",
	})

	vim.cmd("normal! G")
end

vim.api.nvim_create_user_command("CodexLog", function()
	require("codex_log").open_log()
end, {})

return M
