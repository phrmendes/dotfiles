require("writing").markdown()
require("quarto").setup({
	lspFeatures = {
		languages = { "bash", "lua", "python" },
		chunks = "all",
	},
	codeRunner = {
		enabled = true,
		default_method = "slime",
		never_run = { "yaml" },
	},
})
