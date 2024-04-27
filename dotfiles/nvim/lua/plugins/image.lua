local later = require("mini.deps").later

later(function()
	require("img-clip").setup()

	require("image").setup({
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				download_remote_images = true,
				filetypes = { "markdown", "quarto" },
			},
		},
		max_width = 100,
		max_height = 15,
		tmux_show_only_in_active_window = true,
	})
end)
