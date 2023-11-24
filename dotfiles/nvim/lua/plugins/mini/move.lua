local move = require("mini.move")

move.setup({
	mappings = {
		-- visual mode
		down = "<S-j>",
		left = "<S-h>",
		right = "<S-l>",
		up = "<S-k>",
		-- normal mode
		line_down = "<S-j>",
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_up = "<S-k>",
	},
})
