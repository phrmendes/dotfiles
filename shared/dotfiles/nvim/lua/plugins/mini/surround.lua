local wk = require("which-key")

require("mini.surround").setup({
	mappings = {
		add = "gsa",
		delete = "gsd",
		find = "gsf",
		find_left = "gsF",
		highlight = "gsh",
		replace = "gsr",
		update_n_lines = "gsn",
		suffix_last = "l",
		suffix_next = "n",
	},
})

wk.register({
	name = "surround",
}, { prefix = "gs", mode = { "n", "x" } })
