-- ~/.config/nvim/lua/codex_status.lua

local M = {}

local state = require("codex.state")
local mode = require("codex_mode")

local state_labels = {
	running = "Running",
	preview = "Preview",
	validating = "Validating",
	applied = "Applied",
	failed = "Failed",
}

local state_icons = {
	running = "⚙",
	preview = "👁",
	validating = "🧪",
	applied = "✅",
	failed = "✖",
}

local state_hex = {
	unknown = "#565f89",
	running = "#bb9af7",
	preview = "#bb9af7",
	validating = "#e0af68",
	applied = "#9ece6a",
	failed = "#f7768e",

	health_running = "#e0af68",
	health_ready = "#9ece6a",
	health_blocked = "#f7768e",
}

local mode_labels = {
	balanced = "Balanced",
	fast = "Fast",
	strict = "Strict",
	refactor = "Refactor",
}

local active_states = {
	running = true,
	preview = true,
	validating = true,
}

local function current_state_obj()
	return state.get() or {}
end

local function current_state()
	local s = current_state_obj()
	return s.status or "unknown"
end

local function current_mode()
	local m = mode.current() or "unknown"
	return mode_labels[m] or "Unknown"
end

local function normalize_message(msg)
	msg = tostring(msg or "")
	msg = vim.trim(msg)

	if msg == "" then
		return nil
	end

	local rewrites = {
		["Running Codex request"] = "Working",
		["Preview ready"] = "Diff ready",
		["Diff preview open"] = "Diff ready",
		["Function refactor preview open"] = "Refactor ready",
		["Validating candidate with clang"] = "Checking",
		["Changes applied successfully"] = "Applied",
		["Preview closed without applying changes"] = "Preview closed",
		["No changes produced"] = "No changes",
		["Explanation opened"] = "Explain ready",
		["Output opened in scratch buffer"] = "Output ready",
		["Scratchpad output opened"] = "Scratchpad ready",
		["Codex output written to file"] = "File written",
		["Codex execution failed"] = "Execution failed",
		["clang validation rejected candidate"] = "Clang rejected",
		["Codex output rejected by refactor guard"] = "Guard rejected",
		["Codex violated output rules"] = "Rule break",
		["Codex violated output rules; not writing file"] = "Rule break",
	}

	if rewrites[msg] then
		msg = rewrites[msg]
	end

	msg = msg:gsub("^Codex%s+", "")
	msg = msg:gsub("%.$", "")
	msg = vim.trim(msg)

	if msg == "" then
		return nil
	end

	local max_len = 28
	if vim.fn.strdisplaywidth(msg) > max_len then
		msg = vim.fn.strcharpart(msg, 0, max_len - 1) .. "…"
	end

	return msg
end

function M.icon()
	local s = current_state()
	return state_icons[s] or "?"
end

function M.state_label()
	local s = current_state()
	return state_labels[s] or "Unknown"
end

function M.color()
	local s = current_state()

	-- Active operational states always take colour precedence.
	if active_states[s] then
		return state_hex[s] or state_hex.unknown
	end

	-- Runtime health/session state takes precedence over passive cache.
	local ok_state, health_state = pcall(require, "codex.health_state")
	if ok_state and health_state then
		local hs = health_state.get() or {}

		if hs.status == "running" then
			return state_hex.health_running
		elseif hs.status == "ready" then
			return state_hex.health_ready
		elseif hs.status == "blocked" then
			return state_hex.health_blocked
		end
	end

	-- Passive cache may warn if last known health was blocked.
	-- Cached PASS must not claim this session is ready.
	local ok_cache, health_cache = pcall(require, "codex.health_cache")
	if ok_cache and health_cache then
		local cached = health_cache.read()

		if cached.status == "FAIL" then
			return state_hex.health_blocked
		end
	end

	return state_hex.unknown
end

function M.short_message()
	local s = current_state()
	if not active_states[s] then
		return nil
	end

	local obj = current_state_obj()
	return normalize_message(obj.message)
end

function M.status()
	local s = current_state()

	-- Active operational states always take precedence.
	if active_states[s] then
		local icon = M.icon()
		local label = M.state_label()
		local msg = M.short_message()

		if msg and msg ~= "" then
			return string.format("%s Codex %s · %s — %s", icon, label, current_mode(), msg)
		end

		return string.format("%s Codex %s · %s", icon, label, current_mode())
	end

	-- Runtime health/session state takes precedence over passive cache.
	local ok_state, health_state = pcall(require, "codex.health_state")
	if ok_state and health_state then
		local hs = health_state.get() or {}

		if hs.status == "running" or hs.status == "ready" or hs.status == "blocked" then
			return hs.message
		end
	end

	-- Passive cache may warn if last known health was blocked.
	-- Cached PASS must not claim this session is ready.
	local ok_cache, health_cache = pcall(require, "codex.health_cache")
	if ok_cache and health_cache then
		local cached = health_cache.read()

		if cached.status == "FAIL" then
			return "✖ Codex Blocked"
		end
	end

	return "? Codex Unknown"
end

return M