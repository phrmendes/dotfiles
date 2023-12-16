local quarto = require("quarto")

local map = require("utils").map

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

map({
	key = "<leader>mq",
	command = quarto.quartoPreview,
	desc = "Quarto preview",
	buffer = 0,
}, {
	silent = true,
	noremap = true,
})
