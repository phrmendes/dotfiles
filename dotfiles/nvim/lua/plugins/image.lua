require("image").setup({
	backend = "kitty",
	integrations = {
		markdown = {
			filetypes = { "markdown", "quarto" },
		},
	},
})

require("img-clip").setup()
