require("image").setup({
	backend = "ueberzug",
	integrations = {
		markdown = {
			filetypes = { "markdown", "quarto" },
		},
	},
})
