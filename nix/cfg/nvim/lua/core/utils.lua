local get_cursor = vim.api.nvim_win_get_cursor
local get_lines = vim.api.nvim_buf_get_lines
local get_number = vim.api.nvim_buf_get_number
local set_cursor = vim.api.nvim_win_set_cursor
local set_lines = vim.api.nvim_buf_set_lines

local M = {}

M.md_toggle = function()
	local checked_character = "x"
	local checked_checkbox = "%[" .. checked_character .. "%]"
	local unchecked_checkbox = "%[ %]"
	local new_line = ""

	local bufnr = get_number(0)
	local cursor = get_cursor(0)

	local start_line = cursor[1] - 1
	local current_line = get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

	local checkbox = {
		contains_unchecked = function(line)
			return string.find(line, unchecked_checkbox)
		end,
		check = function(line)
			return line:gsub(unchecked_checkbox, checked_checkbox)
		end,
		uncheck = function(line)
			return line:gsub(checked_checkbox, unchecked_checkbox)
		end,
	}

	if checkbox.contains_unchecked(current_line) then
		new_line = checkbox.check(current_line)
	else
		new_line = checkbox.uncheck(current_line)
	end

	set_lines(bufnr, start_line, start_line + 1, false, { new_line })
	set_cursor(0, cursor)
end

M.normalize = function(str)
	local tableAccents = {}
	tableAccents["À"] = "A"
	tableAccents["Á"] = "A"
	tableAccents["Â"] = "A"
	tableAccents["Ã"] = "A"
	tableAccents["Ä"] = "A"
	tableAccents["Ç"] = "C"
	tableAccents["È"] = "E"
	tableAccents["É"] = "E"
	tableAccents["Ê"] = "E"
	tableAccents["Ì"] = "I"
	tableAccents["Í"] = "I"
	tableAccents["Î"] = "I"
	tableAccents["Ò"] = "O"
	tableAccents["Ó"] = "O"
	tableAccents["Ô"] = "O"
	tableAccents["Õ"] = "O"
	tableAccents["Ù"] = "U"
	tableAccents["Ú"] = "U"
	tableAccents["Û"] = "U"
	tableAccents["à"] = "a"
	tableAccents["á"] = "a"
	tableAccents["â"] = "a"
	tableAccents["ã"] = "a"
	tableAccents["ç"] = "c"
	tableAccents["è"] = "e"
	tableAccents["é"] = "e"
	tableAccents["ê"] = "e"
	tableAccents["ì"] = "i"
	tableAccents["í"] = "i"
	tableAccents["î"] = "i"
	tableAccents["ò"] = "o"
	tableAccents["ó"] = "o"
	tableAccents["ô"] = "o"
	tableAccents["õ"] = "o"
	tableAccents["ù"] = "u"
	tableAccents["ú"] = "u"
	tableAccents["û"] = "u"

	return str:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents)
end

M.match_pattern = function(string, pattern)
	local match = string:match(pattern)

	if match then
		return true
	else
		return false
	end
end

return M
