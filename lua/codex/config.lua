local M = {}

local config = {
	model = "gpt-5.4-mini",

	cli = {
		executable = "codex",
		skip_git_repo_check = true, -- allow Codex operation outside Git repos
	},

	health = {
		min_cli_version = "0.120.0",
		model_probe_enabled = true,
	},
}

function M.get()
	return config
end

return M
