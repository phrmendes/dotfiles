local g = vim.g
local map = vim.keymap.set

-- [[ unbind keys ]] ----------------------------------------------------
local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	map({ "n", "x" }, key, "<Nop>", { noremap = true, silent = true })
end

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ keymaps ]] --------------------------------------------------------
map("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true, desc = "Word wrap" })
map("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true, desc = "Word wrap" })

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (V)" })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (H)" })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase window (H)" })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease window (V)" })

map("n", "<Leader>-", "<C-w>s", { desc = "Split window (H)" })
map("n", "<Leader>W", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<Leader>\\", "<C-w>v", { desc = "Split window (V)" })
map("n", "<Leader>bq", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all unfocused" })
map("n", "<Leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<Leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<Leader>x", "<C-w>q", { desc = "Close window" })
