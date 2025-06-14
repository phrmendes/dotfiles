local add, now = MiniDeps.add, MiniDeps.now

now(function()
	add({ source = "folke/lazydev.nvim" })

	require("lazydev").setup({
		library = {
			{ path = require("nix.luvit-meta"), words = { "vim%.uv" } },
			{ vim.env.HOME .. "/Projects/dotfiles/dotfiles/nvim/lua" },
		},
	})
end)
