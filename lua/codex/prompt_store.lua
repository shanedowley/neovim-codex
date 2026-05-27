-- ~/.config/nvim/lua/codex/prompt_store.lua
local M = {}

local CONFIG_PROMPT_DIR = vim.fn.expand("~/.config/nvim/codex/prompts")

local DEFAULTS = {
	explain_c = [[
Explain the following C/C++ snippet for a developer who wants to understand it quickly.

Output format:
## What this does
- 2–4 bullets explaining the purpose and flow.

## Key details
- 2–5 bullets explaining important language/runtime details that matter here.

## Risks or gotchas
- Mention only issues that are directly relevant to this snippet.
- Separate compile-time issues from runtime undefined behavior.
- Do not list abstract categories unless they actually apply.

## Better approach
- Give one practical improvement if useful.
- Do not rewrite the code unless explicitly asked.

Rules:
- Be accurate about C/C++ semantics.
- If context is missing, state the assumption briefly.
- Avoid essay openings like "I’m checking the snippet..."
- Avoid taxonomy dumps such as A/B/C/D unless specifically needed.
- Maximum 12 bullets total.
- Keep it scannable.
]],

	explain_generic = [[
Explain the following {{filetype}} snippet step-by-step.

Rules:
- First, echo the snippet exactly as you received it in a fenced block labeled: ```received ... ```.
- Be strictly accurate about the language semantics and runtime behavior. If unsure, say so explicitly.
- Focus on what THIS snippet does and why (control flow, data flow, key language features used).
- Call out likely errors, edge cases, and surprising behavior, but don’t invent context not present.
- Keep it concise: maximum 12 bullets.
- Do NOT rewrite the code unless I ask.
]],

	apply = [[
You are rewriting ONLY the selected text provided below.

Return ONLY the replacement text BETWEEN these exact markers, and NOTHING else:
<<<BEGIN>>>
(replacement lines)
<<<END>>>

ABSOLUTE RULES:
- Output must contain BOTH markers, always.
- No explanation, no questions, no advice.
- No markdown fences/backticks in your output.
- Preserve indentation and line breaks.
- Output must be valid code for the same language as the input.

If you cannot comply, your entire output MUST be exactly:
<<<BEGIN>>>
ERROR
<<<END>>>

Instruction:
{{instruction}}

Selected text:
<<<SELECTED>>>
{{selected_text}}
<<<END_SELECTED>>>
]],

	raw_rewrite = [[
You will be given a code snippet below.
Apply my instruction to that snippet.

ABSOLUTE OUTPUT RULES:
- Output ONLY the rewritten code. No prose. No explanations. No questions.
- No markdown fences/backticks.
- Preserve indentation.
{{line_count_rule}}

Instruction:
{{instruction}}
]],

	unified_diff = [[
Generate a unified diff that applies my instruction to the provided snippet.

ABSOLUTE OUTPUT RULES:
- Output ONLY a unified diff. No prose. No explanations.
- No markdown fences/backticks.
- Use these exact filenames in the headers:
  --- a/selection
  +++ b/selection
- Include at least one hunk header starting with @@.

Instruction:
{{instruction}}
]],

	entire_file_rewrite = [[
You will be given an entire file below.
Apply my instruction to it.

ABSOLUTE OUTPUT RULES:
- Output ONLY the full rewritten file contents. No prose. No patch format. No approvals talk.
- No markdown fences/backticks.
- Preserve content you are not changing.

Instruction:
{{instruction}}
]],
}

local function read_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local content = fd:read("*a")
	fd:close()
	return content
end

local function trim_trailing_newlines(s)
	return (s or ""):gsub("\n+$", "")
end

local function trim(s)
	return vim.trim(s or "")
end

local function parse_prompt_file(content)
	content = content or ""
	content = trim_trailing_newlines(content)

	if content == "" then
		return nil, "empty"
	end

	local lines = vim.split(content, "\n", { plain = true })

	local sep_idx = nil
	for i, line in ipairs(lines) do
		if trim(line) == "---" then
			sep_idx = i
			break
		end
	end

	-- Structured format:
	-- VERSION: v2
	-- NAME: apply
	--
	-- ---
	-- <prompt body>
	if sep_idx then
		local body_lines = {}
		for i = sep_idx + 1, #lines do
			body_lines[#body_lines + 1] = lines[i]
		end

		local body = trim_trailing_newlines(table.concat(body_lines, "\n"))
		if trim(body) == "" then
			return nil, "malformed"
		end

		return body, "structured"
	end

	-- Legacy format: whole file is the body.
	if trim(content) == "" then
		return nil, "empty"
	end

	return content, "legacy"
end

function M.dir()
	return CONFIG_PROMPT_DIR
end

function M.path_for(name)
	return CONFIG_PROMPT_DIR .. "/" .. name .. ".md"
end

function M.get(name)
	local path = M.path_for(name)
	local content = read_file(path)

	if not content then
		return DEFAULTS[name], path, "fallback_missing"
	end

	local body, kind = parse_prompt_file(content)
	if body and body ~= "" then
		return body, path, "external_" .. kind
	end

	if kind == "empty" then
		return DEFAULTS[name], path, "fallback_empty"
	end

	return DEFAULTS[name], path, "fallback_malformed"
end

function M.version()
	local parts = {}

	for name, _ in pairs(DEFAULTS) do
		local content, _, source = M.get(name)
		parts[#parts + 1] = name .. ":" .. tostring(#(content or "")) .. ":" .. tostring(source or "unknown")
	end

	table.sort(parts)
	return "store:" .. table.concat(parts, "|")
end

function M.defaults()
	return vim.deepcopy(DEFAULTS)
end

return M
