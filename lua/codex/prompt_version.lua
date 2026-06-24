local M = {}

local prompt = require("codex_prompt")
local store = require("codex.prompt_store")
local window = require("codex.window")

local PROMPT_NAMES = {
	"raw_rewrite",
	"apply",
	"explain_c",
	"explain_generic",
	"unified_diff",
	"entire_file_rewrite",
}

local function fingerprint(content)
	content = tostring(content or "")

	if vim.fn.exists("*sha256") == 1 then
		return vim.fn.sha256(content)
	end

	return "unavailable"
end

local function display_source_label(source)
	source = tostring(source or "unknown")

	if source == "external_legacy" then
		return "external (legacy)"
	end
	if source == "external_structured" then
		return "external (structured)"
	end
	if source == "fallback_missing" then
		return "fallback (missing)"
	end
	if source == "fallback_empty" then
		return "fallback (empty)"
	end
	if source == "fallback_malformed" then
		return "fallback (malformed)"
	end

	return source
end

function M.read()
	local items = {}

	for _, name in ipairs(PROMPT_NAMES) do
		local content, path, source = store.get(name)
		items[#items + 1] = {
			name = name,
			path = path,
			source = source,
			source_label = display_source_label(source),
			length = #(content or ""),
			fingerprint = fingerprint(content),
		}
	end

	return {
		active_version = prompt.version and prompt.version() or "unknown",
		store_version = store.version and store.version() or "unknown",
		prompt_dir = store.dir and store.dir() or "unknown",
		items = items,
	}
end

function M.render_lines()
	local info = M.read()

	local lines = {
		"Codex Prompt Version",
		"====================",
		"",
		"Active version: " .. tostring(info.active_version or "-"),
		"Store version:  " .. tostring(info.store_version or "-"),
		"Prompt dir:     " .. tostring(info.prompt_dir or "-"),
		"",
		"Prompt files:",
	}

	for _, item in ipairs(info.items or {}) do
		lines[#lines + 1] = ""
		lines[#lines + 1] = item.name
		lines[#lines + 1] = "  source: " .. tostring(item.source_label or item.source or "-")
		lines[#lines + 1] = "  path:   " .. tostring(item.path or "-")
		lines[#lines + 1] = "  length: " .. tostring(item.length or 0)
		lines[#lines + 1] = "  sha256: " .. tostring(item.fingerprint or "-")
	end

	return lines
end

local function open_report_buffer(lines)
	return window.open({
		name = "codex://prompt-version",
		lines = lines,
		filetype = "markdown",
		close_desc = "Close Codex prompt version",
	})
end

function M.show()
	open_report_buffer(M.render_lines())
end

return M
