local map = require("utils").map
local section = require("utils").section
local open_uri = require("utils").open_uri_under_cursor

local keys = { "<Space>", "<", ">" }

for _, key in ipairs(keys) do
	vim.keymap.set({ "n", "x" }, key, "<Nop>", { noremap = true, silent = true })
end

vim.g.multi_cursor_use_default_mapping = 0
vim.g.VM_mouse_mappings = 1

section({
	mode = { "n", "x" },
	key = "<leader><space>",
	name = "local leader",
})

section({
	key = "<leader><tab>",
	name = "tabs",
})

section({
	key = "<leader>b",
	name = "buffers",
})

section({
	mode = { "n", "x" },
	key = "<leader>f",
	name = "files/find",
})

map({
	key = "k",
	command = [[v:count == 0 ? "gk" : "k"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

map({
	key = "j",
	command = [[v:count == 0 ? "gj" : "j"]],
	desc = "Word wrap",
}, {
	expr = true,
	silent = true,
})

map({
	mode = "i",
	key = "jk",
	command = "<ESC>",
	desc = "Exit insert mode",
}, {
	noremap = true,
	silent = true,
})

map({
	mode = "i",
	key = "kj",
	command = "<ESC>",
	desc = "Exit insert mode",
}, {
	noremap = true,
	silent = true,
})

map({
	mode = "t",
	key = "<ESC><ESC>",
	command = "<C-\\><C-n>",
	desc = "Exit terminal mode",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "+",
	command = "<cmd>resize +2<cr>",
	desc = "Increase window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "-",
	command = "<cmd>vertical resize -2<cr>",
	desc = "Decrease window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "=",
	command = "<cmd>vertical resize +2<cr>",
	desc = "Increase window (H)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "_",
	command = "<cmd>resize -2<cr>",
	desc = "Decrease window (V)",
}, {
	noremap = true,
	silent = true,
})

map({
	key = "[<TAB>",
	command = "<cmd>tabprevious<cr>",
	desc = "Previous tab",
})

map({
	key = "]<TAB>",
	command = "<cmd>tabnext<cr>",
	desc = "Next tab",
})

map({
	key = "<C-d>",
	command = "<C-d>zz",
	desc = "Page down",
})

map({
	key = "<C-u>",
	command = "<C-u>zz",
	desc = "Page up",
})

map({
	key = "go",
	command = open_uri,
	desc = "Open URI under cursor",
})

map({
	key = "<leader>u",
	command = "<cmd>UndotreeToggle<cr>",
	desc = "Toggle undo tree",
})

map({
	key = "<leader>-",
	command = "<cmd>split<cr>",
	desc = "Split window (H)",
})

map({
	key = "<leader>\\",
	command = "<cmd>vsplit<cr>",
	desc = "Split window (V)",
})

map({
	key = "<leader>W",
	command = "<cmd>wq<cr>",
	desc = "Save and quit",
})

map({
	key = "<leader>q",
	command = "<cmd>confirm q<cr>",
	desc = "Quit",
})

map({
	key = "<leader>w",
	command = "<cmd>w<cr>",
	desc = "Save",
})

map({
	key = "<leader>x",
	command = "<C-w>q",
	desc = "Close window",
})

map({
	key = "<leader>=",
	command = "<C-w>=",
	desc = "Resize and make windows equal",
})

map({
	key = "<leader><TAB>d",
	command = "<cmd> bd <bar> tabclose <bar> startinsert<cr>",
	desc = "Close",
})

map({
	key = "<leader><TAB>n",
	command = "<cmd>tabnext<cr>",
	desc = "New",
})

map({
	key = "<leader><TAB>q",
	command = "<cmd>tabonly<cr>",
	desc = "Close",
})

map({
	key = "<leader>bG",
	command = "<cmd>blast<cr>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bg",
	command = "<cmd>bfirst<cr>",
	desc = "Go to last buffer",
})

map({
	key = "<leader>bq",
	command = "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>",
	desc = "Close all unfocused",
})

map({
	key = "<localleader>q",
	command = "<cmd>TroubleToggle quickfix<cr>",
	desc = "Quickfix",
})

map({
	key = "<localleader>l",
	command = "<cmd>TroubleToggle loclist<cr>",
	desc = "Loclist",
})
