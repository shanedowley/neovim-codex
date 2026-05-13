local M = {}

local function log_path()
	return vim.fn.expand(vim.fn.stdpath("state") .. "/codex.log")
end

local function parse_kv_line(line)
	local item = {}

	for key, value in line:gmatch("([%w_]+)=([^%s]+)") do
		item[key] = value
	end

	return item
end

local function read_log_lines()
	local path = log_path()

	if vim.fn.filereadable(path) ~= 1 then
		return nil, "Codex log file not found: " .. path
	end

	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok or not lines then
		return nil, "Failed to read Codex log: " .. path
	end

	return lines, nil
end

local function tonumber_or_nil(x)
	return tonumber(x)
end

local function find_latest_op_latency_index(lines)
	for i = #lines, 1, -1 do
		local line = lines[i]
		if line:find("event=latency", 1, true) and line:find(" op=", 1, true) then
			local item = parse_kv_line(line)
			if item.event == "latency" and item.op and item.op ~= "" then
				return i, item
			end
		end
	end
	return nil, nil
end

function M.read_latest()
	local lines, err = read_log_lines()
	if not lines then
		return nil, err
	end

	if #lines == 0 then
		return nil, "Codex log is empty"
	end

	local anchor_index, anchor = find_latest_op_latency_index(lines)
	if not anchor_index or not anchor then
		return nil, "No latency events with operation name found in Codex log"
	end

	local out = {
		op = anchor.op or "unknown",
		result = anchor.result or "-",
		codex_exec_ms = nil,
		validate_ms = nil,
		total_ms = nil,
	}

	for i = anchor_index, 1, -1 do
		local line = lines[i]
		if line:find("event=latency", 1, true) then
			local ev = parse_kv_line(line)
			if ev.event == "latency" and ev.op == out.op then
				if ev.stage == "codex_exec" and not out.codex_exec_ms then
					out.codex_exec_ms = tonumber_or_nil(ev.elapsed_ms)
				end
				if ev.stage == "validate" and not out.validate_ms then
					out.validate_ms = tonumber_or_nil(ev.elapsed_ms)
				end
				if ev.result and out.result == "-" then
					out.result = ev.result
				end
			end
		end

		if out.codex_exec_ms and out.validate_ms then
			break
		end
	end

	local total = 0
	local any = false

	if out.codex_exec_ms then
		total = total + out.codex_exec_ms
		any = true
	end

	if out.validate_ms then
		total = total + out.validate_ms
		any = true
	end

	if any then
		out.total_ms = total
	end

	return out, nil
end

function M.read_recent(limit)
	limit = limit or 10

	local lines, err = read_log_lines()
	if not lines then
		return nil, err
	end

	local events = {}

	for i = #lines, 1, -1 do
		local line = lines[i]
		if line:find("event=latency", 1, true) then
			local item = parse_kv_line(line)

			if item.event == "latency" and item.elapsed_ms then
				item.elapsed_ms = tonumber_or_nil(item.elapsed_ms)

				if item.elapsed_ms then
					events[#events + 1] = item
				end
			end

			if #events >= limit then
				break
			end
		end
	end

	return events, nil
end

local function fmt_ms(value)
	if not value then
		return "-"
	end
	return string.format("%d ms", value)
end

local function summarize_recent(events)
	local summary = {
		count = 0,
		pass = 0,
		fail = 0,
		total_ms = 0,
		average_ms = nil,
		slowest = nil,
	}

	for _, ev in ipairs(events or {}) do
		summary.count = summary.count + 1
		summary.total_ms = summary.total_ms + ev.elapsed_ms

		if ev.result == "PASS" then
			summary.pass = summary.pass + 1
		elseif ev.result == "FAIL" then
			summary.fail = summary.fail + 1
		end

		if not summary.slowest or ev.elapsed_ms > summary.slowest.elapsed_ms then
			summary.slowest = ev
		end
	end

	if summary.count > 0 then
		summary.average_ms = math.floor(summary.total_ms / summary.count)
	end

	return summary
end

function M.render_lines()
	local info, err = M.read_latest()
	if not info then
		return {
			"Codex Latency Report",
			"====================",
			"",
			"Error: " .. tostring(err),
		}
	end

	local recent, recent_err = M.read_recent(10)
	local summary = summarize_recent(recent or {})

	local lines = {
		"Codex Latency Report",
		"====================",
		"",
		"Last operation",
		"--------------",
		"Operation:         " .. tostring(info.op or "-"),
		"Result:            " .. tostring(info.result or "-"),
		"Codex execution:   " .. fmt_ms(info.codex_exec_ms),
		"Clang validate:    " .. fmt_ms(info.validate_ms),
		"Total observed:    " .. fmt_ms(info.total_ms),
		"",
		"Recent latency summary",
		"----------------------",
		"Events counted:     " .. tostring(summary.count),
		"PASS:               " .. tostring(summary.pass),
		"FAIL:               " .. tostring(summary.fail),
		"Average:            " .. fmt_ms(summary.average_ms),
	}

	if summary.slowest then
		lines[#lines + 1] = "Slowest:            "
			.. fmt_ms(summary.slowest.elapsed_ms)
			.. " | "
			.. tostring(summary.slowest.op or "-")
			.. " | "
			.. tostring(summary.slowest.result or "-")
			.. " | "
			.. tostring(summary.slowest.stage or "-")
	else
		lines[#lines + 1] = "Slowest:            -"
	end

	if recent_err then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "Recent read warning: " .. tostring(recent_err)
	end

	lines[#lines + 1] = ""
	lines[#lines + 1] = "Recent events"
	lines[#lines + 1] = "-------------"

	if not recent or #recent == 0 then
		lines[#lines + 1] = "No recent latency events found."
	else
		for _, ev in ipairs(recent) do
			lines[#lines + 1] = string.format(
				"- %s | %s | %s | %s",
				fmt_ms(ev.elapsed_ms),
				tostring(ev.op or "-"),
				tostring(ev.result or "-"),
				tostring(ev.stage or "-")
			)
		end
	end

	return lines
end

local function open_report_buffer(lines)
	local bufname = "codex://latency"
	local bufnr = vim.fn.bufnr(bufname)

	if bufnr == -1 then
		vim.cmd("botright new")
		bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(bufnr, bufname)
	else
		vim.cmd("botright sbuffer " .. bufnr)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].filetype = "markdown"

	return bufnr
end

function M.show()
	open_report_buffer(M.render_lines())
end

return M

