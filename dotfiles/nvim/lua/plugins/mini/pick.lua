require("mini.pick").setup({
	mappings = {
		choose_marked = "<c-q>",
		refine = "<c-cr>",
		refine_marked = "<m-cr>",
	},
	window = {
		config = {
			border = require("utils").borders.border,
		},
	},
})
