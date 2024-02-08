local lualine = require("lualine")

local venv = function()
	if vim.env.CONDA_DEFAULT_ENV then
		return string.format("󱔎 %s (conda)", vim.env.CONDA_DEFAULT_ENV)
	end

	if vim.env.VIRTUAL_ENV then
		return string.format(" %s (venv)", vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t"))
	end

	return ""
end

local metals = function()
	if vim.g.metals_status ~= "" then
		return " " .. vim.g.metals_status
	end

	return ""
end

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
		lualine_a = { { "mode", icon = { "", align = "left" } } },
		lualine_b = {
			"branch",
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			"diagnostics",
		},
		lualine_c = {
			metals,
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
