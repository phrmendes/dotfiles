local bufremove = require("mini.bufremove")
local map = require("utils").map

bufremove.setup()

map({
	key = "<leader>bd",
	cmd = bufremove.delete,
	desc = "Delete",
})

map({
	key = "<leader>bw",
	cmd = bufremove.wipeout,
	desc = "Wipeout",
})
