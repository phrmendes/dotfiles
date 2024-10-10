require("dressing").setup({
	input = {
		enabled = true,
		border = require("utils").borders.border,
		relative = "win",
	},
	select = {
		enabled = true,
		backend = { "builtin" },
	},
})
