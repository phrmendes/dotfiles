-- random
vim.keymap.set({ "n", "v" }, "s", "<nop>")
vim.keymap.set("n", "<c-d>", "<c-d>zz", { noremap = true, desc = "Half page down" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { noremap = true, desc = "Half page up" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true, desc = "Clear highlights" })

-- macro keys
vim.keymap.set("n", "Q", "@q", { noremap = true, expr = true, desc = "Record macro" })
vim.keymap.set("v", "Q", ":norm @q<cr>", { noremap = true, expr = true, desc = "Replace with macro" })

-- better default keys
vim.keymap.set("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("v", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("v", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })

-- leader keys
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split (H)" })
vim.keymap.set("n", "<leader>=", "<c-w>=", { noremap = true, desc = "Resize and make windows equal" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { noremap = true, desc = "Split (V)" })
vim.keymap.set("n", "<leader>W", "<cmd>wall!<cr>", { noremap = true, desc = "Write all" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>silent w!<cr>", { noremap = true, desc = "Write" })
vim.keymap.set("n", "<leader>x", "<cmd>copen<cr>", { noremap = true, desc = "Quickfix" })

-- buffer keys
vim.keymap.set("n", "<leader>bG", "<cmd>blast<cr>", { noremap = true, desc = "Last" })
vim.keymap.set("n", "<leader>bg", "<cmd>bfirst<cr>", { noremap = true, desc = "First" })
vim.keymap.set("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", {
	noremap = true,
	desc = "Keep this",
})

-- tab keys
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous" })
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next" })
vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>", { noremap = true, desc = "Last" })
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { noremap = true, desc = "Close" })
vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { noremap = true, desc = "First" })
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>", { noremap = true, desc = "Keep" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New" })
vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { noremap = true, desc = "Edit" })
