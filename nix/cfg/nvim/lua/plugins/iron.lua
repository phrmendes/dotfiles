local core = require("iron.core")
local pythonft = require("iron.fts.python")
local view = require("iron.view")

core.setup({
	config = {
		repl_open_cmd = view.split("25%"),
		repl_definition = {
			python = pythonft.ipython,
		},
	},
	keymaps = {
		send_line = "<C-c><C-c>",
		exit = "<C-c><C-q>",
		send_file = "<C-c><C-f>",
		visual_send = "<C-c><C-c>",
	},
	highlight = { italic = false },
	ignore_blank_lines = true,
})
