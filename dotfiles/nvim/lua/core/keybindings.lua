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
	cmd = "<CMD>norm @q<CR>",
	desc = "Replay macro",
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
	cmd = "<CMD>resize +2<CR>",
	desc = "Increase window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "-",
	cmd = "<CMD>vertical resize -2<CR>",
	desc = "Decrease window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "=",
	cmd = "<CMD>vertical resize +2<CR>",
	desc = "Increase window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "_",
	cmd = "<CMD>resize -2<CR>",
	desc = "Decrease window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "[<TAB>",
	cmd = "<CMD>tabprevious<CR>",
	desc = "Previous tab",
})

map({
	key = "]<TAB>",
	cmd = "<CMD>tabnext<CR>",
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
	cmd = "<CMD>UndotreeToggle<CR>",
	desc = "Toggle undo tree",
})

map({
	key = "<leader>-",
	cmd = "<CMD>split<CR>",
	desc = "Split window (H)",
})

map({
	key = "<leader>\\",
	cmd = "<CMD>vsplit<CR>",
	desc = "Split window (V)",
})

map({
	key = "<leader>W",
	cmd = "<CMD>wq<CR>",
	desc = "Save and quit",
})

map({
	key = "<leader>q",
	cmd = "<CMD>confirm q<CR>",
	desc = "Quit",
})

map({
	key = "<leader>w",
	cmd = "<CMD>w<CR>",
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
	key = "<leader><TAB>n",
	cmd = "<CMD>tabnext<CR>",
	desc = "New",
})

map({
	key = "<leader><TAB>q",
	cmd = "<CMD>tabonly<CR>",
	desc = "Close",
})

map({
	key = "<leader>bG",
	cmd = "<CMD>blast<CR>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bg",
	cmd = "<CMD>bfirst<CR>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bq",
	cmd = "<CMD>%bdelete<bar>edit#<bar>bdelete#<CR>",
	desc = "Close all unfocused",
})

map({
	key = "<localleader>q",
	cmd = "<CMD>TroubleToggle quickfix<CR>",
	desc = "Quickfix",
})

map({
	key = "<localleader>l",
	cmd = "<CMD>TroubleToggle loclist<CR>",
	desc = "Loclist",
})