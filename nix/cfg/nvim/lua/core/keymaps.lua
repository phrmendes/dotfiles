local map = vim.keymap.set
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

-- general keymaps
map("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
map("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- resize
map("n", "+", ":resize +2<CR>", opts)
map("n", "-", ":vertical resize -2<CR>", opts)
map("n", "=", ":vertical resize +2<CR>", opts)
map("n", "_", ":resize -2<CR>", opts)
