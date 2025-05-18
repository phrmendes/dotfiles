local keymap = require("mini.keymap")

keymap.setup()

keymap.map_combo({ "i", "c", "x", "s" }, "jk", "<bs><bs><esc>")
keymap.map_combo({ "i", "c", "x", "s" }, "kj", "<bs><bs><esc>")
keymap.map_combo({ "i", "c", "x", "s" }, "<esc><esc>", function() vim.cmd("nohlsearch") end)
