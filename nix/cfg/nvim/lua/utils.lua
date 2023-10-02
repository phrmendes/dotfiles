-- [[ variables ]] ------------------------------------------------------
local fn = vim.fn
local get_cursor = vim.api.nvim_win_get_cursor
local get_lines = vim.api.nvim_buf_get_lines
local get_number = vim.api.nvim_buf_get_number
local set_cursor = vim.api.nvim_win_set_cursor
local set_lines = vim.api.nvim_buf_set_lines

-- [[ imports ]] --------------------------------------------------------
local dap = require("dap")
local gitsigns = require("gitsigns")
local wk = require("which-key")

-- [[ module functions ]] -----------------------------------------------
local M = {}

M.section = function(key, name, prefix, mode)
	wk.register({
		[key] = { name = name },
	}, { prefix = prefix, mode = mode })
end

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

M.git = {
	stage_hunk = function()
		gitsigns.stage_hunk({ fn.line("."), fn.line("v") })
	end,
	reset_hunk = function()
		gitsigns.reset_hunk({ fn.line("."), fn.line("v") })
	end,
}

M.conditional_breakpoint = function()
	dap.set_breakpoint(fn.input("Breakpoint condition: "))
end

return M
