local M = {}

local failure = require("codex.failure")
local last_failure = nil

local function failure_store_path()
	return vim.fn.stdpath("state") .. "/codex_last_failure.json"
end

local function now_string()
	return os.date("%Y-%m-%d %H:%M:%S")
end

local function copy(tbl)
	return vim.deepcopy(tbl)
end

local function basename(path)
	if not path or path == "" then
		return "-"
	end
	return vim.fn.fnamemodify(path, ":t")
end

local function open_scratch(lines, title, filetype)
	title = title or "Codex Failure"
	filetype = filetype or "text"

	local bufname = "codex://" .. title
	local bufnr = vim.fn.bufnr(bufname)

	if bufnr == -1 then
		vim.cmd("botright new")
		bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(bufnr, bufname)
	else
		vim.cmd("botright sbuffer " .. bufnr)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines or {})
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].filetype = filetype

	return bufnr
end

local function render_failure_lines(f)
	local lines = {
		"Codex Recovery Report",
		"=====================",
		"",
		("Failure kind: %s"):format(tostring(f.kind or "-")),
		("Stage:        %s"):format(tostring(f.stage or "-")),
		("Operation:    %s"):format(tostring(f.op or "-")),
		("Mode:         %s"):format(tostring(f.mode or "-")),
		("File:         %s"):format(tostring(f.file or "-")),
		("File name:    %s"):format(tostring(f.file_name or basename(f.file))),
		("Updated at:   %s"):format(tostring(f.updated_at or "-")),
		"",
		"Reason:",
		tostring(f.reason or "-"),
		"",
		"Captured output:",
	}

	local payload = f.lines or { "No diagnostic output available." }
	for _, line in ipairs(payload) do
		lines[#lines + 1] = line
	end

	return lines
end

local function normalize_lines_payload(lines)
	if type(lines) == "table" then
		return lines
	end

	if type(lines) == "string" and lines ~= "" then
		return vim.split(lines, "\n", { plain = true })
	end

	return { "No diagnostic output available." }
end

local function write_last_failure(failure)
	local path = failure_store_path()
	local json = vim.json.encode(failure)

	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	vim.fn.writefile({ json }, path)
end

local function read_last_failure()
	local path = failure_store_path()

	if vim.fn.filereadable(path) ~= 1 then
		return nil
	end

	local lines = vim.fn.readfile(path)
	local raw = table.concat(lines, "\n")

	if raw == "" then
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, raw)
	if not ok or type(decoded) ~= "table" then
		return nil
	end

	return decoded
end

function M.capture(opts)
	opts = opts or {}

	last_failure = {
		kind = failure.normalize(opts.kind),
		stage = opts.stage or "-",
		op = opts.op,
		mode = opts.mode,
		file = opts.file,
		file_name = basename(opts.file),
		reason = opts.reason or "codex_failure",

		title = opts.title or "Codex Failure",
		lines = normalize_lines_payload(opts.lines),
		updated_at = now_string(),
	}

	pcall(write_last_failure, last_failure)

	return copy(last_failure)
end

function M.get_last_failure()
	if last_failure then
		return copy(last_failure)
	end

	local persisted = read_last_failure()
	if persisted then
		last_failure = persisted
		return copy(last_failure)
	end

	return nil
end

function M.clear_last_failure()
	last_failure = nil
end

function M.render_last_failure_lines()
	local f = M.get_last_failure()

	if not f then
		return {
			"Codex Recovery Report",
			"=====================",
			"",
			"No failure has been captured in this session.",
		}
	end

	return render_failure_lines(f)
end

function M.show_last_failure()
	open_scratch(M.render_last_failure_lines(), "Recovery", "text")
end

function M.show_failure(opts)
	opts = opts or {}

	local reason = opts.reason or "codex_failure"
	local title = opts.title or "Codex Failure"
	local captured = M.capture(opts)
	local level = failure.is_user_cancelled(captured.kind) and vim.log.levels.INFO or vim.log.levels.ERROR

	vim.notify(reason, level, { title = "Codex" })
	open_scratch(render_failure_lines(captured), title, "text")
end

function M.can_explain_with_codex(failure_report)
	if not failure_report then
		return false, "No failure has been captured."
	end

	local kind = failure.normalize(failure_report.kind)

	if kind == failure.kinds.healthcheck_not_pass or kind == failure.kinds.healthcheck_error then
		return false, "Cannot explain healthcheck failures with Codex. Run :CodexHealth for diagnostics."
	end

	return true, nil
end

return M
