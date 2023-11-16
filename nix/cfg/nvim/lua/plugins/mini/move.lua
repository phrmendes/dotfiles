local move = require("mini.move")

move.setup({
	mappings = {
		-- visual mode
		down = "<M-j>",
		left = "<M-h>",
		right = "<M-l>",
		up = "<M-k>",
		-- normal mode
		line_down = "<M-j>",
		line_left = "<M-h>",
		line_right = "<M-l>",
		line_up = "<M-k>",
	},
})
