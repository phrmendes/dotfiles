if not vim.g.neovide then
	local image = require("image")

	image.setup({
		backend = "ueberzug",
		integrations = {
			markdown = {
				enabled = true,
				only_render_image_at_cursor = true,
				filetypes = { "markdown", "quarto" },
			},
		},
		max_width = 100,
		max_height = 15,
		editor_only_render_when_focused = false,
		tmux_show_only_in_active_window = true,
	})
end
