require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown" },
	},
	indent = { enable = true },
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			scope_incremental = false,
			node_decremental = "<BS>",
		},
	},
	textobjects = {
		move = {
			enable = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		},
	},
})

require("treesitter-context").setup()
