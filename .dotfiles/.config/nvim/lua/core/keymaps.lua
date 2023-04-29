local keymap = vim.keymap
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = " "

-- general keymaps
keymap.set("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
keymap.set("n", "x", '"_x', opts) -- delete single caracter without copy to register
keymap.set("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- vimwiki
keymap.set("n", "<CR>", "<cmd>VimwikiFollowLink<cr>", opts) -- open link
keymap.set("n", "<Backspace>", "<cmd>VimwikiGoBackLink<cr>", opts) -- go back
keymap.set("n", "<Tab>", "<cmd>VimwikiNextLink<cr>", opts) -- go to next link
keymap.set("n", "<S-Tab>", "<cmd>VimwikiPrevLink<cr>", opts) -- go to previous link
keymap.set("n", "<C-c><C-c>", "<cmd>VimwikiToggleListItem<cr>", opts) -- toggle list item
keymap.set("n", "<C-c><C-n>", "<cmd>VimwikiNextTask<cr>", opts) -- go to next task
keymap.set("n", "<C-c>Left", "<cmd>VimwikiTableMoveColumnLeft<cr>", opts) -- move table column left
keymap.set("n", "<C-c>Right", "<cmd>VimwikiTableMoveColumnRight<cr>", opts) -- move table column right

-- multi cursor
g.multi_cursor_use_default_mapping = 0
g.multi_cursor_start_word_key = "<C-i>"
g.multi_cursor_select_all_word_key = "<A-i>"
g.multi_cursor_start_key = "g<C-i>"
g.multi_cursor_select_all_key = "g<A-i>"
g.multi_cursor_next_key = "<C-n>"
g.multi_cursor_prev_key = "<C-p>"
g.multi_cursor_skip_key = "<C-x>"
g.multi_cursor_quit_key = "<Esc>"
