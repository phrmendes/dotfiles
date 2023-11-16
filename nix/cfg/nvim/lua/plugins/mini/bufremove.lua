local bufremove = require("mini.bufremove")

local map = vim.keymap.set

bufremove.setup()

map("n", "<Leader>bd", bufremove.delete, { desc = "Delete buffer" })
