local wk = require("which-key")

wk.register({
	s = { "<Plug>(Luadev-RunLine)", "Lua: send to REPL" },
}, { prefix = "<localleader>", mode = "n", buffer = 0 })

wk.register({
	s = { "<Plug>(Luadev-Run)", "Lua: send to REPL" },
}, { prefix = "<localleader>", mode = "x", buffer = 0 })
