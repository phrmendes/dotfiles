require("nvim-treesitter.configs").setup({
	indent = { enable = true },
	textobjects = {
		select = { enable = false },
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
			scope_incremental = "<c-a>",
			node_decremental = "<c-bs>",
		},
	},
})
