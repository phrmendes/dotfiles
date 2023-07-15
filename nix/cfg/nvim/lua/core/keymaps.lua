local map = vim.keymap.set
local g = vim.g
local opts = {noremap = true, silent = true}

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

-- multiple cursors
g.multi_cursor_use_default_mapping = 0
g.multi_cursor_start_word_key = "<C-m>"
g.multi_cursor_select_all_word_key = "<A-n>"
g.multi_cursor_start_key = "g<C-m>"
g.multi_cursor_select_all_key = "g<A-n>"
g.multi_cursor_next_key = "<C-n>"
g.multi_cursor_prev_key = "<C-p>"
g.multi_cursor_skip_key = "<C-s>"
g.multi_cursor_quit_key = "<Esc>"
