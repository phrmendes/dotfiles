local map = vim.keymap.set
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

-- general keymaps
map("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
map("t", "jk", "<C-\\><C-n>", opts) -- exit terminal mode pressing 'jk'

-- vimwiki
map("n","<localleader><CR>", "<cmd>VimwikiFollowLink<cr>", opts) -- open link
map("n","<localleader><Backspace>", "<cmd>VimwikiGoBackLink<cr>", opts) -- go back
map("n","<localleader><Tab>", "<cmd>VimwikiNextLink<cr>", opts) -- go to next link
map("n","<localleader>c", "<cmd>VimwikiToggleListItem<cr>", opts) -- toggle list item
map("n","<localleader>n", "<cmd>VimwikiNextTask<cr>", opts) -- go to next task
map("n","<localleader>Left", "<cmd>VimwikiTableMoveColumnLeft<cr>", opts) -- move table column left
map("n","<localleader>Right", "<cmd>VimwikiTableMoveColumnRight<cr>", opts) -- move table column right

-- python debugger
map("v","<localleader>dp","<cmd>lua require('dap-python').debug_selection()<cr>", opts)
