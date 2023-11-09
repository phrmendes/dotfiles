local quarto = require("quarto")

quarto.setup({
	keymap = {
		definition = "gd",
		hover = "gh",
		references = "gR",
		rename = "gr",
	},
})
