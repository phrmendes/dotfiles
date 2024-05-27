require("markdown").setup({
	mappings = {
		inline_surround_toggle = "gs",
		inline_surround_toggle_line = "gs",
		inline_surround_delete = "ds",
		inline_surround_change = "cs",
		link_add = "gl",
		link_follow = "gx",
		go_curr_heading = false,
		go_parent_heading = false,
		go_next_heading = "]]",
		go_prev_heading = "[[",
	},
})

require("headlines").setup()
