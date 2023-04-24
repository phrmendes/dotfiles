local core = require("iron.core")
local view = require("iron.view")
local pyfts = require("iron.fts.python")

core.setup({
	config = {
		repl_open_cmd = view.right("40%"),
		repl_definition = {
			python = pyfts.ptipython,
		},
	},
	keymaps = {
		clear = "<space>sc",
		cr = "<space>s<cr>",
		exit = "<space>sq",
		interrupt = "<space>s<space>",
		send_file = "<space>sf",
		send_line = "<space>sl",
		send_motion = "<space>ss",
		visual_send = "<space>ss",
	},
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true,
})
