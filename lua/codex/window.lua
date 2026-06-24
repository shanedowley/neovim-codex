local M = {}

function M.open(opts)
	opts = opts or {}

	local name = opts.name or "codex://window"
	local lines = opts.lines or {}
	local filetype = opts.filetype or "markdown"
	local close_desc = opts.close_desc or "Close Codex window"

	local bufnr = vim.fn.bufnr(name)

	if bufnr == -1 or not vim.api.nvim_buf_is_valid(bufnr) then
		vim.cmd("botright new")
		bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(bufnr, name)
	else
		vim.cmd("botright sbuffer " .. bufnr)
	end

	pcall(vim.treesitter.stop, bufnr)

	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].filetype = filetype

	vim.bo[bufnr].readonly = false
	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].readonly = true

	local function close()
		if vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end

	vim.keymap.set("n", "q", close, {
		buffer = bufnr,
		silent = true,
		noremap = true,
		desc = close_desc,
	})

	vim.keymap.set("n", "<Esc>", close, {
		buffer = bufnr,
		silent = true,
		noremap = true,
		desc = close_desc,
	})

	return bufnr
end

return M
