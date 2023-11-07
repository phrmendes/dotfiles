local lualine = require("lualine")

local metals_status = function()
	return vim.g["metals_status"] or ""
end

lualine.setup({
	options = {
		theme = "catppuccin",
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename", "lsp_progress" },
		lualine_x = { metals_status, "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
