local wk = require("which-key")

wk.setup({
	plugins = { spelling = false },
	window = {
		border = "single",
	},
})

wk.register({
	mode = { "n", "v" },
	["gs"] = { name = "+surround" },
	["<leader><tab>"] = { name = "+tabs" },
	["<leader>b"] = { name = "+buffers" },
	["<leader>f"] = { name = "+files/find" },
	["<leader>g"] = { name = "+git" },
	["<leader>i"] = { name = "+IA" },
	["<leader>o"] = { name = "+obsidian" },
	["<leader>t"] = { name = "+todo" },
})
