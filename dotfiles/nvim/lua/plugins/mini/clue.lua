local clue = require("mini.clue")

clue.setup({
	triggers = {
		-- leader triggers
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },
		-- local leader triggers
		{ mode = "n", keys = "<localleader>" },
		{ mode = "x", keys = "<localleader>" },
		-- built-in completion
		{ mode = "i", keys = "<c-x>" },
		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		-- `s` key
		{ mode = "n", keys = "s" },
		{ mode = "x", keys = "s" },
		-- marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		-- registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<c-r>" },
		{ mode = "c", keys = "<c-r>" },
		-- window commands
		{ mode = "n", keys = "<c-w>" },
		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
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
		{ mode = "n", keys = "<leader>l", desc = "+labels" },
	},
	window = {
		delay = 500,
		config = {
			width = "auto",
			border = require("utils").border,
		},
	},
})
