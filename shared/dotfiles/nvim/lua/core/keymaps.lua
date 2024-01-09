local map = require("utils").map
local section = require("utils").section

local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	vim.keymap.set({ "n", "v" }, key, "<Nop>", { noremap = true, silent = true })
end

vim.g.VM_mouse_mappings = 1

section({
	key = "<leader><tab>",
	name = "tabs",
})

section({
	key = "<leader>b",
	name = "buffers",
})

section({
	mode = { "n", "v" },
	key = "<leader>f",
	name = "files/find",
})

map({
	mode = "n",
	key = "Q",
	cmd = "@qj",
	desc = "Replay macro",
})

map({
	mode = "v",
	key = "Q",
	cmd = "<cmd>norm @q<cr>",
	desc = "Replay macro",
})

map({
	mode = "n",
	key = "gS",
	cmd = "<cmd>sort<cr>",
	desc = "Sort selected lines",
})

map({
	key = "k",
	cmd = [[v:count == 0 ? "gk" : "k"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

map({
	key = "j",
	cmd = [[v:count == 0 ? "gj" : "j"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

map({
	mode = "i",
	key = "jk",
	cmd = "<ESC>",
	desc = "Exit insert mode",
}, {
	noremap = true,
	silent = true,
})

map({
	mode = "i",
	key = "kj",
	cmd = "<ESC>",
	desc = "Exit insert mode",
}, {
	noremap = true,
	silent = true,
})

map({
	mode = "t",
	key = "<ESC><ESC>",
	cmd = "<C-\\><C-n>",
	desc = "Exit terminal mode",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "+",
	cmd = "<cmd>resize +2<cr>",
	desc = "Increase window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "-",
	cmd = "<cmd>vertical resize -2<cr>",
	desc = "Decrease window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "=",
	cmd = "<cmd>vertical resize +2<cr>",
	desc = "Increase window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "_",
	cmd = "<cmd>resize -2<cr>",
	desc = "Decrease window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "[<TAB>",
	cmd = "<cmd>tabprevious<cr>",
	desc = "Previous tab",
})

map({
	key = "]<TAB>",
	cmd = "<cmd>tabnext<cr>",
	desc = "Next tab",
})

map({
	key = "<C-d>",
	cmd = "<C-d>zz",
	desc = "Page down",
})

map({
	key = "<C-u>",
	cmd = "<C-u>zz",
	desc = "Page up",
})

map({
	key = "<leader>u",
	cmd = "<cmd>UndotreeToggle<cr>",
	desc = "Toggle undo tree",
})

map({
	key = "<leader>-",
	cmd = "<cmd>split<cr>",
	desc = "Split window (H)",
})

map({
	key = "<leader>\\",
	cmd = "<cmd>vsplit<cr>",
	desc = "Split window (V)",
})

map({
	key = "<leader>W",
	cmd = "<cmd>wq<cr>",
	desc = "Save and quit",
})

map({
	key = "<leader>q",
	cmd = "<cmd>confirm q<cr>",
	desc = "Quit",
})

map({
	key = "<leader>w",
	cmd = "<cmd>w<cr>",
	desc = "Save",
})

map({
	key = "<leader>x",
	cmd = "<C-w>q",
	desc = "Close window",
})

map({
	key = "<leader>=",
	cmd = "<C-w>=",
	desc = "Resize and make windows equal",
})

map({
	key = "<leader><TAB>d",
	cmd = "<cmd> bd <bar> tabclose <bar> startinsert<cr>",
	desc = "Delete",
})

map({
	key = "<leader><TAB>n",
	cmd = "<cmd>tabnext<cr>",
	desc = "New",
})

map({
	key = "<leader><TAB>q",
	cmd = "<cmd>tabonly<cr>",
	desc = "Close",
})

map({
	key = "<leader>bG",
	cmd = "<cmd>blast<cr>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bg",
	cmd = "<cmd>bfirst<cr>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bq",
	cmd = "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>",
	desc = "Close all unfocused",
})

map({
	key = "<localleader>q",
	cmd = "<cmd>TroubleToggle quickfix<cr>",
	desc = "Quickfix",
})

map({
	key = "<localleader>l",
	cmd = "<cmd>TroubleToggle loclist<cr>",
	desc = "Loclist",
})
