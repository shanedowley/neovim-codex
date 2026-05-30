local M = {}

local function cache_path()
	return vim.fn.stdpath("state") .. "/codex_health.json"
end

function M.path()
	return cache_path()
end

function M.read()
	local path = cache_path()

	if vim.fn.filereadable(path) ~= 1 then
		return {
			status = "UNKNOWN",
			message = "? Codex Unknown",
			checked_at = nil,
			reason = "missing_cache",
		}
	end

	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok or not lines or #lines == 0 then
		return {
			status = "UNKNOWN",
			message = "? Codex Unknown",
			checked_at = nil,
			reason = "unreadable_cache",
		}
	end

	local decoded_ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded_ok or type(data) ~= "table" then
		return {
			status = "UNKNOWN",
			message = "? Codex Unknown",
			checked_at = nil,
			reason = "invalid_cache",
		}
	end

	if data.status == "PASS" then
		data.message = data.message or "✓ Codex Ready"
		return data
	end

	if data.status == "FAIL" then
		data.message = data.message or "✖ Codex Blocked"
		return data
	end

	return {
		status = "UNKNOWN",
		message = "? Codex Unknown",
		checked_at = data.checked_at,
		reason = "unknown_status",
	}
end

function M.write(result)
	local status = result and result.status or "UNKNOWN"

	local message = "? Codex Unknown"
	if status == "PASS" then
		message = "✓ Codex Ready"
	elseif status == "FAIL" then
		message = "✖ Codex Blocked"
	end

	local payload = {
		status = status,
		checked_at = os.time(),
		message = message,
	}

	local path = cache_path()
	local dir = vim.fn.fnamemodify(path, ":h")
	vim.fn.mkdir(dir, "p")

	local ok, encoded = pcall(vim.json.encode, payload)
	if not ok then
		return false
	end

	local write_ok = pcall(vim.fn.writefile, { encoded }, path)
	return write_ok
end

function M.summary()
	return M.read().message
end

return M
