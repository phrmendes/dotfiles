require("nvim-treesitter.configs").setup({
	indent = { enable = true },
	autotag = { enable = true },
	textobjects = {
		move = {
			enable = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		},
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "org" },
	},
	markdown = {
		enable = true,
		mappings = {
			inline_surround_toggle = "gm",
			inline_surround_toggle_line = "gmm",
			inline_surround_delete = "ds",
			inline_surround_change = "cs",
			link_add = "gl",
			link_follow = "gx",
			go_curr_heading = false,
			go_parent_heading = false,
			go_next_heading = "]]",
			go_prev_heading = "[[",
		},
	},
})
