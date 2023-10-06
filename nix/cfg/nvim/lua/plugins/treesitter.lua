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
			scope_incremental = false,
			node_decremental = "<BS>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["aC"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
				["iC"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
				["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
				["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
				["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
				["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
				["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
				["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
				["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
				["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next = {
				["]C"] = { query = "@comment.outer", desc = "Next comment" },
				["]c"] = { query = "@class.outer", desc = "Next class" },
				["]f"] = { query = "@call.outer", desc = "Next function call" },
				["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
				["]l"] = { query = "@loop.outer", desc = "Next loop" },
				["]m"] = { query = "@function.outer", desc = "Next method/function definition" },
			},
			goto_previous = {
				["[C"] = { query = "@comment.outer", desc = "Previous comment" },
				["[c"] = { query = "@class.outer", desc = "Previous class" },
				["[f"] = { query = "@call.outer", desc = "Previous function call" },
				["[i"] = { query = "@conditional.outer", desc = "Previous conditional" },
				["[l"] = { query = "@loop.outer", desc = "Previous loop" },
				["[m"] = { query = "@function.outer", desc = "Previous method/function def" },
			},
		},
	},
})

context.setup()
