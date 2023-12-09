local map = vim.keymap.set

-- [[ unbind keys ]] ----------------------------------------------------
local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	map({ "n", "x" }, key, "<Nop>", { noremap = true, silent = true })
end

-- [[ multi cursor ]] ---------------------------------------------------
vim.g.multi_cursor_use_default_mapping = 0
vim.g.VM_mouse_mappings = 1

-- [[ keymaps ]] --------------------------------------------------------
map("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true, desc = "Word wrap" })
map("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true, desc = "Word wrap" })

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (V)" })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (H)" })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (H)" })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (V)" })

map("n", "[<TAB>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "]<TAB>", "<cmd>tabnext<cr>", { desc = "Next tab" })

map("n", "<C-d>", "<C-d>zz", { desc = "Page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up" })
map("n", "<C-s>", "<cmd>'<,'>sort<cr>", { desc = "Sort" })

map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split window (H)" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split window (V)" })
map("n", "<leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<leader>Q", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix" })
map("n", "<leader>l", "<cmd>TroubleToggle loclist<cr>", { desc = "Loclist" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", "<C-w>q", { desc = "Close window" })
map("n", "<leader>=", "<C-w>=", { desc = "Resize and make windows equal" })

map("n", "<leader><TAB>d", "<cmd> bd <bar> tabclose <bar> startinsert<cr>", { desc = "Close tab" })
map("n", "<leader><TAB>n", "<cmd>tabnext<cr>", { desc = "New tab" })
map("n", "<leader><TAB>q", "<cmd>tabonly<cr>", { desc = "Close tab" })

map("n", "<leader>bG", "<cmd>blast<cr>", { desc = "Go to last buffer" })
map("n", "<leader>bg", "<cmd>bfirst<cr>", { desc = "Go to last buffer" })
map("n", "<leader>bq", "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", { desc = "Close all unfocused" })
