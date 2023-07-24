local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<C-c>", "<cmd>lua require('toggle-checkbox').toggle()<cr>", opts)
