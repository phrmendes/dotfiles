local keymap = vim.keymap
local g = vim.g
local opts = { noremap = true, silent = true }

-- leader keys
g.mapleader = " "
g.maplocalleader = " "

-- general keymaps
keymap.set("i", "jk", "<ESC>", opts) -- exit insert mode pressing 'jk'
keymap.set("n", "x", '"_x', opts) -- delete single caracter without copy to register
keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
keymap.set("n", "<A-h>", ":MoveHChar(-1)<CR>", opts)
keymap.set("n", "<A-l>", ":MoveHChar(1)<CR>", opts)
keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)
