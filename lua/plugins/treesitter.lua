-- lua/plugins/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		indent = { enable = true },
		ensure_installed = {
			"lua",
			"c",
			"cpp",
			"vim",
			"rust",
			"json",
			"markdown",
			"markdown_inline",
			"css",
			"javascript",
			"yaml",
			"llvm",
			"html",
			"d",
			"c_sharp",
			"angular",
			"asm",
			"bash",
			"liquid",
			"sql",
		},
		auto_install = true,
		highlight = {
			enable = true,
			disable = function(lang, buf)
				if lang == "markdown" or lang == "text" then
					return true
				end

				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		},

		-- Disabled temporarily:
		-- nvim-treesitter-textobjects is currently throwing:
		-- E5108: attempt to call method 'start' (a nil value)
		--
		-- Backlog:
		-- R1.1/R1.2 — Reintroduce Treesitter textobjects safely with
		-- version-compatible config.
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		-- Force Treesitter to treat .z80 files as asm.
		vim.treesitter.language.register("asm", "z80")

		-- Syntax fallback for .z80 files.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "z80",
			callback = function()
				vim.bo.syntax = "asm"
			end,
		})
	end,
}
