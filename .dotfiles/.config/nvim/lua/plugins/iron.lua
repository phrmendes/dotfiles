local core = require("iron.core")
local pyfts = require("iron.fts.python")
local view = require("iron.view")

core.setup({
	config = {
		repl_open_cmd = view.split("25%"),
		repl_definition = {
			python = pyfts.ptipython,
		},
	},
	keymaps = {
		clear = "<localleader>rc",
		exit = "<localleader>rq",
		send_file = "<localleader>rf",
		send_line = "<localleader>rl",
		visual_send = "<localleader>rs",
		interrupt = "<localleader>ri",
	},
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true,
})
