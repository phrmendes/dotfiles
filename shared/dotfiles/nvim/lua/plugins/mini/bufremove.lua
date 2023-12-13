local bufremove = require("mini.bufremove")
local map = require("utils").map

bufremove.setup()

map({
	key = "<leader>bd",
	command = bufremove.delete,
	desc = "Delete",
})

map({
	key = "<leader>bw",
	command = bufremove.wipeout,
	desc = "Wipeout",
})
