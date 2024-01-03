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
	tmux_show_only_in_active_window = true,
})

require("img-clip").setup({
	default = {
		drag_and_drop = {
			enabled = true,
			insert_mode = true,
			copy_images = false,
			download_images = true,
		},
	},
})
