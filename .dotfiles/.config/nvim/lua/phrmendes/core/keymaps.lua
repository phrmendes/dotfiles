local keymap = vim.keymap

-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- general keymaps
keymap.set("i", "jk", "<ESC>") -- exit insert mode pressing 'jk'
keymap.set("n", "<leader>nh", ":nohl<CR>") -- clear highlights
keymap.set("n", "x", '"_x') -- delete single caracter without copy to register
keymap.set("n", "<leader>+", "<C-a>") -- increment numbers
keymap.set("n", "<leader>-", "<C-x>") -- decrement numbers
keymap.set("n", "<leader>wv", "<C-w>v") -- split windows vertically
keymap.set("n", "<leader>wh", "<C-w>s") -- split windows horizontally
keymap.set("n", "<leader>we", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>wm", ":MaximizerToggle<CR>") -- maximize window split
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>td", ":tabclose<CR>") -- close new tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab
keymap.set("n", "<leader>gg", ":LazyGit<CR>") -- open LazyGit
keymap.set("n", "<leader>ft", ":NvimTreeToggle<CR>") -- open nvim-tree
keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true<CR>") -- find files
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>") -- live grep in project
keymap.set("n", "<leader>fs", ":Telescope grep_string<CR>") -- find string in cursor
keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>") -- help tags
keymap.set("n", "<leader>bb", ":Telescope buffers<CR>") -- show all buffers
keymap.set("n", "<leader>vw", ":VimwikiIndex") -- open vimwiki index
