local get_cursor = vim.api.nvim_win_get_cursor
local get_lines = vim.api.nvim_buf_get_lines
local get_number = vim.api.nvim_buf_get_number
local set_cursor = vim.api.nvim_win_set_cursor
local set_lines = vim.api.nvim_buf_set_lines

local cmp = require("cmp")
local dap = require("dap")
local gitsigns = require("gitsigns")
local luasnip = require("luasnip")
local neotest = require("neotest")

-- [[ module functions ]] -----------------------------------------------
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

M.luasnip = {
	expand = function(args)
		luasnip.lsp_expand(args.body)
	end,
	next_cmp = function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
		else
			fallback()
		end
	end,
	prev_cmp = function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end,
	prev_choice = function()
		if luasnip.choice_active() then
			return luasnip.change_choice(-1)
		end
	end,
	next_choice = function()
		if luasnip.choice_active() then
			return luasnip.change_choice(1)
		end
	end,
}

M.dap_conditional_breakpoint = function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
end

M.git = {
	stage_hunk = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("x") })
	end,
	reset_hunk = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("x") })
	end,
}

M.tests = {
	file = function()
		neotest.run.run(vim.fn.expand("%"))
	end,
	debug = function()
		neotest.run.run({ strategy = "dap" })
	end,
}

return M
