require("nvim-treesitter.configs").setup({
	indent = { enable = true },
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
		additional_vim_regex_highlighting = { "markdown" },
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-s>",
			node_incremental = "<c-s>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
	markdown = {
		enable = true,
		mappings = {
			inline_surround_toggle = "gs",
			inline_surround_toggle_line = "gss",
			inline_surround_delete = "ds",
			inline_surround_change = "cs",
			link_add = "gl",
			link_follow = "gx",
			go_curr_heading = "]c",
			go_parent_heading = "]p",
			go_next_heading = "]]",
			go_prev_heading = "[[",
		},
	},
})
