return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = require("nix.luvit-meta"), words = { "vim%.uv" } },
			{ vim.env.HOME .. "/Projects/dotfiles/dotfiles/nvim/lua" },
		},
	},
}
