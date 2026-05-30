-- ~/.config/nvim/lua/codex/health_state.lua

local M = {}

local state = {
	status = "unknown",
	message = "? Codex Unknown",
	updated_at = os.time(),
}

function M.set(status, message)
	state.status = status
	state.message = message
	state.updated_at = os.time()
end

function M.get()
	return vim.deepcopy(state)
end

return M
