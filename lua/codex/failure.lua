local M = {}

M.kinds = {
	healthcheck_not_pass = "healthcheck_not_pass",
	healthcheck_error = "healthcheck_error",
	model_error = "model_error",
	cli_error = "cli_error",
	codex_exec_failed = "codex_exec_failed",
	clang_rejected = "clang_rejected",
	rule_break_output = "rule_break_output",
	guard_rejection = "guard_rejection",
	diff_preview_failed = "diff_preview_failed",
	apply_block_missing = "apply_block_missing",
	wrong_line_count = "wrong_line_count",
	user_cancelled = "user_cancelled",
	unknown_failure = "unknown_failure",
}

local aliases = {
	codex_returned_error = M.kinds.model_error,
	invalid_rewrite = M.kinds.rule_break_output,
	preprocessor_injection_rejected = M.kinds.guard_rejection,
	refactor_guard_rejected = M.kinds.guard_rejection,
	filename_prompt_cancelled = M.kinds.user_cancelled,
	non_file_output_rejected = M.kinds.rule_break_output,
	jobstart_failed = M.kinds.cli_error,
	missing_prompt = M.kinds.cli_error,
}

function M.normalize(kind)
	if not kind or kind == "" then
		return M.kinds.unknown_failure
	end

	if M.kinds[kind] then
		return kind
	end

	return aliases[kind] or kind
end

function M.is_user_cancelled(kind)
	return M.normalize(kind) == M.kinds.user_cancelled
end

return M
