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
		clear = "<localleader>sc",
		exit = "<localleader>sq",
		send_file = "<localleader>sf",
		send_line = "<localleader>sl",
		send_motion = "<localleader>ss",
		visual_send = "<localleader>ss",
	},
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true,
})
