require("image").setup({
	backend = "kitty",
	max_width = 100,
	max_height = 15,
	integrations = {
		markdown = {
			enabled = true,
			download_remote_images = true,
			filetypes = { "markdown", "quarto" },
		},
	},
})
