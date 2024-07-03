local pick = require("mini.pick")

pick.setup({
	mappings = {
		caret_left = "<left>",
		caret_right = "<right>",
		choose = "<cr>",
		choose_in_split = "<c-s>",
		choose_in_tabpage = "<c-t>",
		choose_in_vsplit = "<c-v>",
		choose_marked = "<c-q>",
		delete_char = "<bs>",
		delete_char_right = "<del>",
		delete_left = "<c-u>",
		delete_word = "<c-w>",
		mark = "<c-x>",
		mark_all = "<c-a>",
		move_down = "<c-n>",
		move_start = "<c-g>",
		move_up = "<c-p>",
		paste = "<c-r>",
		refine = "<c-cr>",
		refine_marked = "<s-cr>",
		scroll_down = "<c-d>",
		scroll_left = "<c-h>",
		scroll_right = "<c-l>",
		scroll_up = "<c-u>",
		stop = "<esc>",
		toggle_info = "<s-tab>",
		toggle_preview = "<tab>",
	},
	options = {
		use_cache = true,
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})
