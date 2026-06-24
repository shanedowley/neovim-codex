local M = {}

local memory = require("codex_memory")
local window = require("codex.window")

local function format_timestamp(ts)
	if not ts then
		return "-"
	end

	local n = tonumber(ts)
	if not n then
		return tostring(ts)
	end

	return os.date("%Y-%m-%d %H:%M:%S", n)
end

local function append_multiline(lines, text)
	text = tostring(text or "-")

	for _, line in ipairs(vim.split(text, "\n", { plain = true })) do
		lines[#lines + 1] = line
	end
end

local function open_report_buffer(lines)
	return window.open({
		name = "codex://last-op",
		lines = lines,
		filetype = "markdown",
		close_desc = "Close Codex last operation",
	})
end

function M.read_last_op()
	return memory.get_last_op()
end

function M.render_last_op_lines()
	local last = M.read_last_op()

	if not last then
		return {
			"Codex Last Operation",
			"====================",
			"",
			"No operation has been captured in this session.",
		}
	end

	local lines = {
		"Codex Last Operation",
		"====================",
		"",
		"Operation:      " .. tostring(last.op or "-"),
		"Source:         " .. tostring(memory.get_last_op_source and memory.get_last_op_source() or "-"),
		"Mode:           " .. tostring(last.mode or "-"),
		"Prompt version: " .. tostring(last.prompt_version or "-"),
		"Timestamp:      " .. format_timestamp(last.timestamp),
		"",
		"Prompt:",
	}

	append_multiline(lines, last.prompt or "-")

	return lines
end

function M.show_last_op()
	open_report_buffer(M.render_last_op_lines())
end

function M.repeat_last_op()
	local last = M.read_last_op()

	if not last then
		vim.notify("No last Codex operation captured", vim.log.levels.WARN, { title = "Codex" })
		return
	end

	if not last.prompt or vim.trim(last.prompt) == "" then
		vim.notify("Last Codex operation has no reusable prompt", vim.log.levels.WARN, { title = "Codex" })
		return
	end

	require("codex_cli").open_scratchpad_with_text(last.prompt)
end

return M
