local keymap = vim.keymap
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = " "

-- general keymaps
keymap.set("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
keymap.set("n", "x", '"_x', opts) -- delete single caracter without copy to register
