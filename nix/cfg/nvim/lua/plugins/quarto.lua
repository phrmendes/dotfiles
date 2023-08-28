local quarto = require("quarto")

quarto.setup({
	closePreviewOnExit = true,
	lspFeatures = {
		enabled = true,
		languages = { "python" },
		chunks = "curly",
		diagnostics = {
			enabled = true,
			triggers = { "BufWritePost" },
		},
		completion = {
			enabled = true,
		},
	},
})
