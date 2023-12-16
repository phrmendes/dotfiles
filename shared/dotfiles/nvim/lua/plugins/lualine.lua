local lsp_progress = require("lsp-progress")

lsp_progress.setup()

require("lualine").setup({
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = { left = "█", right = "█" },
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "█" }, right_padding = 2 },
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { lsp_progress.progress },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = {
			{ "location", separator = { right = "█" }, left_padding = 2 },
		},
	},
	disabled_filetypes = { "starter", "neo-tree" },
	globalstatus = true,
})
