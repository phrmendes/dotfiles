local map = vim.keymap.set
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

-- general keymaps
map("i", "jk", "<ESC>", opts)       -- exit insert mode pressing 'jk'
map("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- resize
map("n", "+", "<cmd>resize +2<cr>", opts)
map("n", "-", "<cmd>vertical resize -2<cr>", opts)
map("n", "=", "<cmd>vertical resize +2<cr>", opts)
map("n", "_", "<cmd>resize -2<cr>", opts)

-- multiple cursors
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1
