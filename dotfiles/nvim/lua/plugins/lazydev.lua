require("lazydev").setup({
	library = {
		{ path = require("luvit-meta").path, words = { "vim%.uv" } },
		{ vim.env.HOME .. "/Projects/dotfiles/dotfiles/nvim/lua" },
	},
})
