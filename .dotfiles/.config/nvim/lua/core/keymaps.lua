local keymap = vim.keymap
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

-- general keymaps
keymap.set("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
keymap.set("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- vimwiki
keymap.set("n", ",<CR>", "<cmd>VimwikiFollowLink<cr>", opts) -- open link
keymap.set("n", ",<Backspace>", "<cmd>VimwikiGoBackLink<cr>", opts) -- go back
keymap.set("n", ",<Tab>", "<cmd>VimwikiNextLink<cr>", opts) -- go to next link
keymap.set("n", ",c", "<cmd>VimwikiToggleListItem<cr>", opts) -- toggle list item
keymap.set("n", ",n", "<cmd>VimwikiNextTask<cr>", opts) -- go to next task
keymap.set("n", ",Left", "<cmd>VimwikiTableMoveColumnLeft<cr>", opts) -- move table column left
keymap.set("n", ",Right", "<cmd>VimwikiTableMoveColumnRight<cr>", opts) -- move table column right
