require("writing").markdown()

require("cmp_pandoc").setup({
	filetypes = { "quarto" },
	crossref = {
		enable_nabla = true,
	},
})

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
