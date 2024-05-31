require("mini.pick").setup({
	mappings = {
		mark = "<c-space>",
		mark_all = "<c-a>",
		refine = "<c-cr>",
		refine_marked = "<a-cr>",
	},
	options = {
		use_cache = true,
	},
	window = { config = { border = "rounded" } },
})
