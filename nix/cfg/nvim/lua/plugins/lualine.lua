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
	disabled_filetypes = { "starter" },
	ignore_focus = { "NvimTree" },
	globalstatus = true,
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { metals_status },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
