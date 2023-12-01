local flash = require("flash")

vim.keymap.set("o", "r", flash.remote, { desc = "Remote Flash" })
vim.keymap.set({ "c" }, "<C-s>", flash.toggle, { desc = "Toggle Flash search" })
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter search" })
