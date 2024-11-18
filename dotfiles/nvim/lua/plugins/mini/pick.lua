require("mini.pick").setup({
	mappings = {
		choose_in_split = "<c-->",
		choose_in_tabpage = "<c-t>",
		choose_in_vsplit = "<c-\\>",
		choose_marked = "<c-q>",
		refine = "<a-r>",
		refine_marked = "<c-r>",
		paste = "<c-y>",
		mark_and_move_down = {
			char = "<a-n>",
			func = require("utils").mini.pick.mark_and_move_down,
		},
		unmark_and_move_up = {
			char = "<a-p>",
			func = require("utils").mini.pick.move_up_and_unmark,
		},
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})
