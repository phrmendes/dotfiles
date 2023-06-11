local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

-- syntax
opt.syntax = "on"

-- filetype plugin
cmd([[ filetype plugin on ]])

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and identation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true
opt.showtabline = 1

-- line wrapping
opt.wrap = true

-- global status line
opt.laststatus = 3

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- config cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- disable swap files
opt.swapfile = false

-- save undo history
opt.undofile = true

-- decrease update time
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- better completion experience
opt.completeopt = "noinsert,menuone,noselect"

-- random
opt.iskeyword:append("-")

-- default terminal
opt.shell = "zsh"

-- colorscheme
cmd([[ colorscheme catppuccin-macchiato ]])
