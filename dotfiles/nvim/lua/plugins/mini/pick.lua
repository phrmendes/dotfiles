require("mini.pick").setup({
	mappings = {
		choose_in_split = "<c-->",
		choose_in_tabpage = "<c-t>",
		choose_in_vsplit = "<c-\\>",
		choose_marked = "<c-q>",
		refine = "<c-r>",
		refine_marked = "<c-s-r>",
		paste = "<c-y>",
		mark_and_move_down = {
			char = "<c-s-n>",
			func = require("utils").mini.pick.mark_and_move_down,
		},
		unmark_and_move_up = {
			char = "<c-s-p>",
			func = require("utils").mini.pick.move_up_and_unmark,
		},
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})
