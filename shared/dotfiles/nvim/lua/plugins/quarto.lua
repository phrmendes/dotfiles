local quarto = require("quarto")
local runner = require("quarto.runner")

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

map({
	key = "<leader>ms",
	command = runner.run_cell,
	desc = "Run cell",
	buffer = 0,
}, {
	silent = true,
})

map({
	key = "<leader>ma",
	command = runner.run_all,
	desc = "Run all cells",
	buffer = 0,
}, {
	silent = true,
})
