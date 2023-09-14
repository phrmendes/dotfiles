local treesitter = require("nvim-treesitter.configs")
local context = require("treesitter-context")

treesitter.setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "org" },
	},
	indent = { enable = true },
	autotag = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["of"] = "@function.outer",
				["if"] = "@function.inner",
				["oc"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]o"] = "@function.outer",
				["]i"] = "@class.inner",
			},
			goto_next_end = {
				["]O"] = "@function.outer",
				["]I"] = "@class.outer",
			},
			goto_previous_start = {
				["[o"] = "@function.outer",
				["[i"] = "@class.inner",
			},
			goto_previous_end = {
				["[O"] = "@function.outer",
				["[I"] = "@class.outer",
			},
		},
	},
})

context.setup()
