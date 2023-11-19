local g = vim.g
local map = vim.keymap.set
local wk = require("which-key")

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

wk.register({
	["-"] = { "<C-w>s", "Split window (H)" },
	["W"] = { "<cmd>wq<cr>", "Save and quit" },
	["\\"] = { "<C-w>v", "Split window (V)" },
	Q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
	q = { "<cmd>confirm q<cr>", "Quit" },
	w = { "<cmd>w<cr>", "Save" },
	x = { "<C-w>q", "Close window" },
}, { prefix = "<leader>", mode = "n" })

wk.register({
	name = "buffers",
	q = { "<cmd> w <bar> %bd <bar> e# <bar> bd# <cr><cr>", "Close all unfocused" },
}, { prefix = "<leader>b", mode = "n" })
