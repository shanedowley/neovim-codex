local M = {}

function M.open(opts)
	opts = opts or {}

	local bufname = "codex-output://main"

	local existing = vim.fn.bufnr(bufname)
	if existing ~= -1 and vim.api.nvim_buf_is_valid(existing) then
		local win = vim.fn.bufwinid(existing)
		if win ~= -1 then
			vim.api.nvim_set_current_win(win)
		else
			vim.cmd("botright sbuffer " .. existing)
		end

		local bufnr = existing
		vim.bo[bufnr].modifiable = true
		vim.bo[bufnr].readonly = false
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
			"Codex working…",
			"",
		})
		vim.bo[bufnr].modifiable = false

		return bufnr
	end

	vim.cmd("botright new")

	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(bufnr, bufname)

	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = true
	vim.bo[bufnr].readonly = false
	vim.bo[bufnr].filetype = opts.filetype or "markdown"

	pcall(vim.treesitter.stop, bufnr)

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
		"Codex working…",
		"",
	})

	vim.bo[bufnr].modifiable = false

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end, {
		buffer = bufnr,
		silent = true,
		noremap = true,
		desc = "Close Codex output",
	})

	return bufnr
end

function M.append(bufnr, lines)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	lines = lines or {}
	if #lines == 0 then
		return
	end

	vim.bo[bufnr].modifiable = true
	vim.bo[bufnr].readonly = false

	local line_count = vim.api.nvim_buf_line_count(bufnr)

	if line_count >= 1 then
		local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
		if first == "Codex working…" then
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
			line_count = 0
		end
	end

	vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, false, lines)
	vim.bo[bufnr].modifiable = false

	local win = vim.fn.bufwinid(bufnr)
	if win ~= -1 then
		vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(bufnr), 0 })
	end
end

function M.finish(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].readonly = true
end

function M.fail(bufnr, lines)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	M.append(bufnr, { "", "---", "Codex failed.", "" })
	M.append(bufnr, lines or {})
	M.finish(bufnr)
end

return M
