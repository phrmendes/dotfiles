local lsp_progress = require("lsp-progress")
local lualine = require("lualine")

local venv = require("utils").venv
local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd

lsp_progress.setup({
	client_format = function(client_name, spinner, series_messages)
		return #series_messages > 0 and ("[" .. client_name .. "] " .. spinner) or nil
	end,
})

lualine.setup({
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = {
			right = "█",
			left = "",
		},
	},
	sections = {
		lualine_a = { { "mode", icon = { " ", align = "left" } } },
		lualine_b = {
			"branch",
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			"diagnostics",
		},
		lualine_c = {
			{
				"buffers",
				symbols = { modified = "", alternate_file = "", directory = "" },
			},
		},
		lualine_x = {
			venv,
			lsp_progress.progress,
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = { { "progress", separator = { left = "", right = "" } } },
		lualine_z = { { "location", separator = { left = "", right = "" } } },
	},
	disabled_filetypes = { "starter" },
	globalstatus = true,
	extensions = {
		"neo-tree",
		"nvim-dap-ui",
	},
})

autocmd("User", {
	group = augroup,
	pattern = "LspProgressStatusUpdated",
	callback = lualine.refresh,
})
