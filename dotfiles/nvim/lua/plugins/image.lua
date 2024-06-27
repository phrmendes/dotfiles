if vim.env.KITTY_LISTEN_ON then
	require("image").setup({
		backend = "ueberzug",
		integrations = {
			markdown = {
				filetypes = { "markdown", "quarto" },
			},
		},
	})
end
