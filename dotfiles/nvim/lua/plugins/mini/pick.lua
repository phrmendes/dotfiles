require("mini.pick").setup({
	mappings = {
		refine = "<c-r>",
		refine_marked = "<a-r>",
		paste = "<c-y>",
	},
	window = {
		config = {
			border = require("utils").border,
		},
	},
})

vim.ui.select = require("mini.pick").ui_select
