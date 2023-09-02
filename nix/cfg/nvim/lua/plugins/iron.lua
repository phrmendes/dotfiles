local core = require("iron.core")
local pythonft = require("iron.fts.python")
local scalaft = require("iron.fts.scala")
local shft = require("iron.fts.sh")
local view = require("iron.view")

core.setup({
	config = {
		repl_open_cmd = view.split("25%"),
		repl_definition = {
			python = pythonft.ipython,
			scala = scalaft.scala,
			sh = shft.sh,
		},
	},
	keymaps = {
		send_line = "<shift><space>",
		visual_send = "<shift><space>",
	},
	highlight = { italic = false },
	ignore_blank_lines = true,
})
