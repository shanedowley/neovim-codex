local M = {}

local last_op = nil
local last_op_source = nil

local function store_path()
	return vim.fn.stdpath("state") .. "/codex_last_op.json"
end

local function write_last_op(op)
	local path = store_path()
	local json = vim.json.encode(op)

	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	vim.fn.writefile({ json }, path)
end

local function read_last_op()
	local path = store_path()

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

function M.save_last_op(op)
	last_op = vim.deepcopy(op)
	last_op_source = "session"
	pcall(write_last_op, last_op)
end

function M.get_last_op()
	if last_op then
		return vim.deepcopy(last_op)
	end

	local persisted = read_last_op()
	if persisted then
		last_op = persisted
		last_op_source = "persisted"
		return vim.deepcopy(last_op)
	end

	return nil
end

function M.get_last_op_source()
	return last_op_source or "-"
end

function M.clear_last_op()
	last_op = nil
	last_op_source = nil

	local path = store_path()
	if vim.fn.filereadable(path) == 1 then
		pcall(vim.fn.delete, path)
	end
end

return M

