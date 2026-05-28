local M = {}

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

	local bufnr = vim.fn.bufnr(bufname)

	if bufnr == -1 or not vim.api.nvim_buf_is_valid(bufnr) then
		bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(bufnr, bufname)

		vim.bo[bufnr].buftype = "nofile"
		vim.bo[bufnr].bufhidden = "wipe"
		vim.bo[bufnr].swapfile = false
		vim.bo[bufnr].filetype = "text"

		vim.cmd("botright split")
		vim.api.nvim_win_set_buf(0, bufnr)

		vim.keymap.set("n", "q", function()
			if vim.api.nvim_buf_is_valid(bufnr) then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end, {
			buffer = bufnr,
			silent = true,
			noremap = true,
			desc = "Close Codex log",
		})
	end

	local target_win = nil

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			if not target_win then
				target_win = win
			else
				pcall(vim.api.nvim_win_close, win, true)
			end
		end
	end

	if target_win then
		vim.api.nvim_set_current_win(target_win)
	else
		vim.cmd("botright sbuffer " .. bufnr)
	end

	vim.bo[bufnr].readonly = false
	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].readonly = true

	vim.cmd("normal! G")
end

vim.api.nvim_create_user_command("CodexLog", function()
	require("codex_log").open_log()
end, {})

return M
