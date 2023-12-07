local statusline = require("mini.statusline")

local content = function()
	local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
	local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
	local filename = statusline.section_filename({ trunc_width = 140 })
	local git = statusline.section_git({ trunc_width = 75 })
	local location = statusline.section_location({ trunc_width = 75 })
	local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
	local search = statusline.section_searchcount({ trunc_width = 75 })
	local metals = vim.g.metals_status or ""

	return statusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
		"%<",
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		{ hl = "MiniStatuslineDevinfo", strings = { metals } },
		"%=",
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = mode_hl, strings = { search, location } },
	})
end

statusline.setup({
	set_vim_settings = false,
	content = {
		active = content,
		inactive = nil,
	},
})
