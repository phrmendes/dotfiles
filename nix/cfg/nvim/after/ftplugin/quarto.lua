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
			Q = {
				name = "+quarto",
				p = { "Preview", "<cmd>QuartoPreview<cr>" },
				q = { "Close preview", "<cmd>QuartoClosePreview<cr>" },
				a = { "Activate", "<cmd>QuartoActivate<cr>" },
				h = { "Hover", "<cmd>QuartoHover<cr>" },
				d = { "Diagnostics", "<cmd>QuartoDiagnostics<cr>" },
			},
		},
	},
}

wk.register(leader.normal.mappings, leader.normal.options)
