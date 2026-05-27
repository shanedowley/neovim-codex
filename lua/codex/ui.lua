local M = {}

local uv = vim.uv or vim.loop
local ui_notify = require("ui_notify")

local spinner = {
	timer = nil,
	idx = 1,
	notif_id = nil,
	active = false,
	message = nil,
	started_at_ns = nil,
}

local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function elapsed_ms()
	if not spinner.started_at_ns then
		return 0
	end
	return math.max(0, math.floor((uv.hrtime() - spinner.started_at_ns) / 1e6))
end

local function format_elapsed(ms)
	local total_seconds = math.floor((ms or 0) / 1000)
	local minutes = math.floor(total_seconds / 60)
	local seconds = total_seconds % 60
	return string.format("%02d:%02d", minutes, seconds)
end

local function spinner_text()
	local base = spinner.message or "Codex working…"
	local timer = format_elapsed(elapsed_ms())
	local frame = frames[spinner.idx] or frames[1]
	return string.format("%s %s %s", base, timer, frame)
end

function M.notify(msg, level, opts)
	return ui_notify.notify(msg, level, opts)
end

function M.start(msg)
	if spinner.timer then
		pcall(spinner.timer.stop, spinner.timer)
		pcall(spinner.timer.close, spinner.timer)
		spinner.timer = nil
	end

	spinner.active = true
	spinner.idx = 1
	spinner.message = msg
	spinner.started_at_ns = uv.hrtime()

	spinner.notif_id = ui_notify.notify(spinner_text(), vim.log.levels.INFO, {
		timeout = false,
	})

	vim.schedule(function()
		if not spinner.active then
			return
		end

		spinner.notif_id = ui_notify.update(spinner.notif_id, spinner_text(), vim.log.levels.INFO, {
			timeout = false,
		})
	end)

	spinner.timer = uv.new_timer()
	spinner.timer:start(
		100,
		100,
		vim.schedule_wrap(function()
			if not spinner.active then
				return
			end

			spinner.idx = (spinner.idx % #frames) + 1
			spinner.notif_id = ui_notify.update(spinner.notif_id, spinner_text(), vim.log.levels.INFO, {
				timeout = false,
			})
		end)
	)
end

function M.stop(msg, level)
	spinner.active = false

	if spinner.timer then
		pcall(spinner.timer.stop, spinner.timer)
		pcall(spinner.timer.close, spinner.timer)
		spinner.timer = nil
	end

	if spinner.notif_id then
		spinner.notif_id = ui_notify.update(spinner.notif_id, msg, level or vim.log.levels.INFO, {
			timeout = 1500,
		})
	else
		spinner.notif_id = ui_notify.notify(msg, level or vim.log.levels.INFO, {
			timeout = 1500,
		})
	end

	spinner.notif_id = nil
	spinner.message = nil
	spinner.started_at_ns = nil
end

local operation_labels = {
	explain_selection = "explain",
	explain_selection_fast = "fast explain",
	explain_current_line = "explain",
	explain_text = "explain",

	replace_selection = "replace selection",
	replace_range = "replace",

	apply_inline = "apply inline",
	apply_inline_current_line = "apply inline",

	preview_diff = "preview diff",
	preview_diff_current_line = "preview diff",

	safe_preview_confirm_apply_selection = "safe preview",
	safe_preview_confirm_apply_current_function = "safe refactor",

	run_current_line = "rewrite line",
	run_entire_file = "rewrite file",

	open_output_scratch = "scratch output",
	save_output_to_file_text = "save output",

	explain_failure = "explain failure",
}

local phase_labels = {
	starting = "starting…",
	running = "working…",
	validating = "validating…",
	preview = "preview ready",
	applied = "changes applied",
	failed = "failed",
	blocked = "blocked",
	idle = "idle",
}

function M.phase_message(op, phase)
	local op_label = operation_labels[op] or op or "operation"
	local phase_label = phase_labels[phase] or phase or "working…"

	return string.format("Codex %s %s", op_label, phase_label)
end

return M
