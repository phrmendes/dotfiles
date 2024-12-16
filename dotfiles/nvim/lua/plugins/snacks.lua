require("snacks").setup({
	indent = { enabled = true },
	input = { enabled = true },
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	words = { enabled = true },
	lazygit = { configure = false },
	statuscolumn = {
		enabled = true,
		git = { patterns = { "MiniDiffSign" } },
	},
})
