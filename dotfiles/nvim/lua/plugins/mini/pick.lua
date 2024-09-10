require("mini.pick").setup({
	mappings = {
		choose_marked = "<c-cr>",
		refine = "<c-r>",
		refine_marked = "<c-m>",
		scroll_down = "<c-d>",
		scroll_up = "<c-u>",
		delete_left = "",
		paste = "",
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
