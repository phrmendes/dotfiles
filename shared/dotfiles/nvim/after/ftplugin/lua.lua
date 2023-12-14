local map = require("utils").map

map({
	key = "<localleader>s",
	command = "<Plug>(Luadev-RunLine)",
	desc = "Lua: send to REPL",
	buffer = 0,
})

map({
	mode = "x",
	key = "<localleader>s",
	command = "<Plug>(Luadev-Run)",
	desc = "Lua: send to REPL",
	buffer = 0,
})
