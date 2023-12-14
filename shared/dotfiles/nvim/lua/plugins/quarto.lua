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

require("quarto").setup({
	lspFeatures = {
		languages = { "python", "bash", "lua" },
	},
})
