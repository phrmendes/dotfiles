local autocmd = vim.api.nvim_create_autocmd

require("barbecue").setup({
	create_autocmd = false,
	exclude_filetypes = {
		"starter",
		"Trouble",
		"neo-tree",
	},
})

autocmd({
	"WinScrolled",
	"BufWinEnter",
	"CursorHold",
	"InsertLeave",
	"BufModifiedSet",
}, {
	group = require("utils").augroup,
	callback = function()
		require("barbecue.ui").update()
	end,
})
