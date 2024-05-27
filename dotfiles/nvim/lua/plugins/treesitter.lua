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
		additional_vim_regex_highlighting = { "markdown" },
	},
	markdown = {
		enable = true,
	},
})
