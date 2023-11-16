local files = require("mini.files")

local map = vim.keymap.set

files.setup()

map("n", "<Leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "File explorer" })
