local statusline = require("mini.statusline")

local metals_status = function()
	return vim.g.metals_status or ""
end

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git = statusline.section_git({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })
			local metals = metals_status()

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatusLineDevinfo", strings = { git, diagnostics } },
				"%<", -- mark general truncate point
				{ hl = "MiniStatusLineDevinfo", strings = { metals } },
				{ hl = "MiniStatusLineFilename", strings = { filename } },
				"%=", -- end left alignment
				{ hl = "MiniStatusLineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
	set_vim_settings = false,
})
