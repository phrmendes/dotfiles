local later = require("mini.deps").later

later(function()
	require("image").setup({
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				only_render_image_at_cursor = true,
				download_remote_images = true,
				filetypes = { "markdown", "quarto" },
			},
		},
		max_width = 100,
		max_height = 15,
		editor_only_render_when_focused = false,
	})

	require("img-clip").setup({
		filetypes = {
			markdown = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				drag_and_drop = {
					download_images = false,
				},
			},
			quarto = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				drag_and_drop = {
					download_images = false,
				},
			},
		},
	})
end)
