local bufremove = require("mini.bufremove")
local wk = require("which-key")

bufremove.setup()

wk.register({
	name = "buffers",
	d = { bufremove.delete, "Delete" },
	w = { bufremove.wipeout, "Wipeout" },
}, { prefix = "<leader>b", mode = "n" })
