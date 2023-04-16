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
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true,
})
