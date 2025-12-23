now(function()
	vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

	require("lazydev").setup({
		library = {
			{ path = require("nix.luvit-meta"), words = { "vim%.uv" } },
			{ vim.fs.joinpath(vim.env.HOME, "Projects", "dotfiles", "dotfiles", "nvim", "lua") },
		},
	})
end)
