local M = {}

local config = require("codex.config").get()

function M.build_exec_argv(prompt_text)
	local argv = {
		config.cli.executable,
		"exec",
		"--model",
		config.model,
	}

	if config.cli.skip_git_repo_check then
		table.insert(argv, "--skip-git-repo-check")
	end

	table.insert(argv, prompt_text)

	return argv
end

return M
