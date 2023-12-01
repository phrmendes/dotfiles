local bufremove = require("mini.bufremove")

bufremove.setup()

vim.keymap.set("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
vim.keymap.set("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })
