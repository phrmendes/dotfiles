local augroups = require("utils").augroups
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
	group = augroups.filetype,
	pattern = "go",
	callback = function()
		require("gopher").setup({
			commands = {
				go = "go",
				gomodifytags = "gomodifytags",
				gotests = "gotests",
				impl = "impl",
				iferr = "iferr",
			},
		})
	end,
})
