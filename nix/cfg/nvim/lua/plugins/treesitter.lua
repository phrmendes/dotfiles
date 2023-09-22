local treesitter = require("nvim-treesitter.configs")
local context = require("treesitter-context")

treesitter.setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "org" },
	},
	indent = { enable = true },
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			scope_incremental = "<C-s>",
			node_decremental = "<M-Space>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aC"] = "@comment.outer",
				["aa"] = "@parameter.outer",
				["ac"] = "@class.outer",
				["af"] = "@function.outer",
				["ai"] = "@conditional.outer",
				["al"] = "@loop.outer",
				["iC"] = "@comment.inner",
				["ia"] = "@parameter.inner",
				["ic"] = "@class.inner",
				["if"] = "@function.inner",
				["ii"] = "@conditional.inner",
				["il"] = "@loop.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
			},
			goto_previous = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<localleader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<localleader>A"] = "@parameter.inner",
			},
		},
	},
})

context.setup()
