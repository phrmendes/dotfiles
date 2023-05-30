local map = vim.keymap.set
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

-- general keymaps
map("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
map("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- resize with arrows
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)
map("n", "<C-Up>", ":resize -2<CR>", opts)

-- better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- oil.nvim
map("n", "-", require("oil").open, opts) -- open oil.nvim
