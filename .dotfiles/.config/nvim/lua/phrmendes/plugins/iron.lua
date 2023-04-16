local status, iron = pcall(require, "iron")
if not status then
	return
end

iron.core.setup({
	config = {
		repl_definition = {
			python = require("iron.fts.python").ipython,
		},
	},
	keymaps = {
		send_motion = "<C-s>c",
		visual_send = "<C-s>v",
		send_file = "<C-s>f",
		send_line = "<C-s>l",
		send_mark = "<C-s>m",
		exit = "<C-s>q",
		clear = "<C-s>cl",
	},
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true,
})
