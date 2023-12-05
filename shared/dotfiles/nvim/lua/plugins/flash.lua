local flash = require("flash")

local map = vim.keymap.set

map("o", "r", flash.remote, { desc = "Remote Flash" })
map({ "c" }, "<C-s>", flash.toggle, { desc = "Toggle Flash search" })
map({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
map({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
map({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter search" })
