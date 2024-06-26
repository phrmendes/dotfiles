local clue = require("mini.clue")

clue.setup({
	triggers = {
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },
		{ mode = "n", keys = "<localleader>" },
		{ mode = "x", keys = "<localleader>" },
		{ mode = "n", keys = "<c-w>" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "'" },
		{ mode = "x", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.marks(),
		clue.gen_clues.registers(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
		{ mode = "n", keys = "<leader><tab>", desc = "+tabs" },
		{ mode = "n", keys = "<leader>b", desc = "+buffers" },
		{ mode = "n", keys = "<leader>g", desc = "+git" },
		{ mode = "x", keys = "<leader>g", desc = "+git" },
		{ mode = "n", keys = "<leader>o", desc = "+obsidian" },
		{ mode = "x", keys = "<leader>o", desc = "+obsidian" },
	},
	window = {
		delay = 500,
		config = {
			width = "auto",
			border = "rounded",
		},
	},
})
