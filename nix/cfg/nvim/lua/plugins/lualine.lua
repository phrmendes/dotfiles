local lualine = require("lualine")
local lsp_progress = require("lsp-progress")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local metals_status = function()
	return vim.g["metals_status"] or ""
end

lsp_progress.setup()

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
		lualine_c = { metals_status, lsp_progress.progress },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

local lualine_group = augroup("UserLualine", { clear = true })

autocmd("User", {
	group = lualine_group,
	pattern = "LspProgressStatusUpdated",
	callback = lualine.refresh,
})
