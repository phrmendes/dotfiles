require("lazydev").setup({
	library = {
		{ path = require("paths.luvit-meta"), words = { "vim%.uv" } },
		{ vim.env.HOME .. "/Projects/dotfiles/dotfiles/nvim/lua" },
	},
})
