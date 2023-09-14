local core = require("iron.core")
local pythonft = require("iron.fts.python")
local scalaft = require("iron.fts.scala")
local shft = require("iron.fts.sh")
local view = require("iron.view")
local leader = "<C-i>"

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
		send_line = leader .. "<C-c>",
        exit = leader .. "<C-q>",
        send_file = leader .. "<C-f>",
        visual_send = leader .. "<C-c>",
        cr = leader .. "<cr>",
	},
	highlight = { italic = false },
	ignore_blank_lines = true,
})
