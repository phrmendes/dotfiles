local keymap = vim.keymap
local g = vim.g

-- leader keys
g.mapleader = " "
g.maplocalleader = " "

-- general keymaps
keymap.set("i", "jk", "<ESC>") -- exit insert mode pressing 'jk'
keymap.set("n", "x", '"_x') -- delete single caracter without copy to register
