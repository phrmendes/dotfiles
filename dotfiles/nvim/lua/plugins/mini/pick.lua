require("mini.pick").setup({
	mappings = {
		choose_in_split = "<c-s>",
		choose_in_tabpage = "<c-t>",
		choose_in_vsplit = "<c-v>",
		choose_marked = "<c-q>",
		refine = "<a-r>",
		refine_marked = "<c-r>",
		paste = "<c-y>",
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})

vim.ui.select = require("mini.pick").ui_select
