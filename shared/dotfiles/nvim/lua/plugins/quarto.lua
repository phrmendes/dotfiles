local quarto = require("quarto")
local map = require("utils").map

quarto.setup({
	lspFeatures = {
		languages = { "bash", "lua", "python" },
	},
})

require("otter").setup({
	opts = {
		lsp = {
			hover = {
				border = require("utils").border,
			},
		},
		buffers = {
			set_filetype = true,
		},
	},
})

map({
	key = "<leader>mq",
	command = quarto.quartoPreview,
	desc = "Quarto preview",
	buffer = 0,
}, {
	silent = true,
	noremap = true,
})
