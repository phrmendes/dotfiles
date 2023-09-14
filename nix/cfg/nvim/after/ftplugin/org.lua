local wk = require("which-key")

local leader = {
	normal = {
		options = {
			mode = "n",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		},
		mappings = {
			o = {
				b = { "<cmd>Telescope bibtex<cr>", "org insert bibliography" },
			},
		},
	},
}

wk.register(leader.normal.mappings, leader.normal.options)
