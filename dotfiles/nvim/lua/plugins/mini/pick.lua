require("mini.pick").setup({
	mappings = {
		choose = "<cr>",
		choose_marked = "<c-q>",
		mark = "<tab>",
		refine = "<c-r>",
		refine_marked = "<c-m>",
		scroll_down = "<c-d>",
		scroll_up = "<c-u>",
		toggle_info = "<c-i>",
		toggle_preview = "<m-p>",
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})
