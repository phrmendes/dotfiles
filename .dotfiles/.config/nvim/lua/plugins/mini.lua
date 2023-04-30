local mini_move = require("mini.move")

mini_move.setup({
	mappings = {
		-- visual mode
		left = "<S-h>",
		right = "<S-l>",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_down = "<S-j>",
		line_up = "<S-k>",
	},
})
