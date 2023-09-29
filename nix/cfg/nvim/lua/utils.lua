-- [[ variables ]] ------------------------------------------------------
local buf = vim.lsp.buf
local diag = vim.diagnostic
local fn = vim.fn
local lsp = vim.lsp
local map = vim.keymap.set
local get_cursor = vim.api.nvim_win_get_cursor
local get_lines = vim.api.nvim_buf_get_lines
local get_number = vim.api.nvim_buf_get_number
local set_cursor = vim.api.nvim_win_set_cursor
local set_lines = vim.api.nvim_buf_set_lines

-- [[ imports ]] --------------------------------------------------------
local dap = require("dap")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local terminal = require("FTerm")
local wk = require("which-key")

local telescope = {
	builtin = require("telescope.builtin"),
	extensions = require("telescope").extensions,
	themes = require("telescope.themes"),
}

-- [[ local functions ]] ------------------------------------------------
local telescope_no_previewer = function(fun)
	fun(telescope.themes.get_dropdown({
		previewer = false,
	}))
end

-- [[ module functions ]] -----------------------------------------------
local M = {}

M.section = function(key, name, prefix, mode)
	wk.register({
		[key] = { name = name },
	}, { prefix = prefix, mode = mode })
end

M.on_attach = function()
	map("n", "[d", diag.goto_prev, { desc = "Previous diagnostic message" })
	map("n", "]d", diag.goto_next, { desc = "Next diagnostic message" })
	map("n", "gD", buf.declaration, { desc = "Go to declaration [LSP]" })
	map("n", "gR", telescope.builtin.lsp_references, { desc = "Go to references [LSP]" })
	map("n", "gd", telescope.builtin.lsp_definitions, { desc = "Go to definition [LSP]" })
	map("n", "gh", buf.hover, { desc = "Show hover [LSP]" })
	map("n", "gi", telescope.builtin.lsp_implementations, { desc = "Go to implementation [LSP]" })
	map("n", "gr", buf.rename, { desc = "Rename [LSP]" })
	map("n", "gs", buf.signature_help, { desc = "Signature help [LSP]" })

	M.section("c", "code action [LSP]", "<localleader>", { "n", "v" })
	map({ "n", "v" }, "<localleader>ca", buf.code_action, { desc = "Show available" })

	M.section("l", "LSP", "<leader>", "n")
	map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens" })
	map("n", "<leader>ld", telescope.builtin.diagnostics, { desc = "Diagnostics" })
	map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart" })
	map("n", "<leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
	map("n", "<leader>lw", telescope.builtin.lsp_document_symbols, { desc = "Workspace symbols" })
	map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens" })
	map("n", "<leader>lf", formatters.format, { desc = "Format buffer" })
	map("n", "<leader>ll", diag.loclist, { desc = "Loclist" })
	map("n", "<leader>lo", diag.open_float, { desc = "Open floating diagnostic message" })
	map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart" })
	map("n", "<leader>ls", telescope.builtin.lsp_document_symbols, { desc = "Document symbols" })
	map("n", "<leader>lw", telescope.builtin.lsp_document_symbols, { desc = "Workspace symbols" })
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

M.buffers = {
	search = function()
		telescope_no_previewer(telescope.builtin.current_buffer_fuzzy_find)
	end,
	list = function()
		telescope_no_previewer(telescope.builtin.buffers)
	end,
}

M.files = {
	find = function()
		telescope.builtin.find_files({
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"-g",
				"!.git",
			},
		})
	end,
}

M.git = {
	stage_hunk = function()
		gitsigns.stage_hunk({ fn.line("."), fn.line("v") })
	end,
	reset_hunk = function()
		gitsigns.reset_hunk({ fn.line("."), fn.line("v") })
	end,
	blame_line = function()
		gitsigns.blame_line({ full = true })
	end,
	branches = function()
		telescope_no_previewer(telescope.builtin.git_branches)
	end,
	ui = terminal:new({
		ft = "lazygit",
		cmd = "lazygit",
		dimensions = {
			height = 0.9,
			width = 0.9,
		},
	}),
}

M.conditional_breakpoint = function()
	dap.set_breakpoint(fn.input("Breakpoint condition: "))
end

return M
