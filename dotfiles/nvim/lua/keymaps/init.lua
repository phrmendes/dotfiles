local map = vim.keymap.set
local del_map = vim.keymap.del

del_map("n", "gra")
del_map("n", "gri")
del_map("n", "grn")
del_map("n", "grr")

-- random
map({ "n", "x" }, "s", "<nop>")
map("n", "<c-d>", "<c-d>zz", { noremap = true, desc = "Half page down" })
map("n", "<c-u>", "<c-u>zz", { noremap = true, desc = "Half page up" })

-- better default keys
map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
map("o", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
map("x", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })

-- leader keys
map("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split (H)" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { noremap = true, desc = "Split (V)" })
map("n", "<leader>W", "<cmd>wall!<cr>", { noremap = true, desc = "Write all" })
map("n", "<leader>q", "<cmd>q<cr>", { noremap = true, desc = "Quit" })
map("n", "<leader>w", "<cmd>silent w!<cr>", { noremap = true, desc = "Write" })
map("n", "<leader>x", "<cmd>copen<cr>", { noremap = true, desc = "Quickfix" })

-- buffer keys
map("n", "<leader>bG", "<cmd>blast<cr>", { noremap = true, desc = "Last" })
map("n", "<leader>bg", "<cmd>bfirst<cr>", { noremap = true, desc = "First" })
map("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", { noremap = true, desc = "Keep this" })

-- tab keys
map("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous" })
map("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next" })
map("n", "<leader><tab>G", "<cmd>tablast<cr>", { noremap = true, desc = "Last" })
map("n", "<leader><tab>q", "<cmd>tabclose<cr>", { noremap = true, desc = "Close" })
map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { noremap = true, desc = "First" })
map("n", "<leader><tab>k", "<cmd>tabonly<cr>", { noremap = true, desc = "Keep" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New" })
map("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { noremap = true, desc = "Edit" })
