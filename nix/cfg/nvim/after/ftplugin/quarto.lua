local nabla = require("nabla")
local quarto = require("quarto")
local wk = require("which-key")

quarto.setup()

wk.register({
	p = { nabla.popup, "Preview equation" },
}, { prefix = "<localleader>", mode = "n" })
