local quarto = require("quarto")
local mappings = require("plugins.writing")

quarto.setup({
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

mappings.markdown()
mappings.bullets()
