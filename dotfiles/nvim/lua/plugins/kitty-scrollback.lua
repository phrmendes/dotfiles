require("kitty-scrollback").setup({
	search = {
		callbacks = {
			after_ready = function()
				vim.api.nvim_feedkeys("?", "n", false)
			end,
		},
	},
})
