local lualine = require("lualine")

local venv = require("utils").venv

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