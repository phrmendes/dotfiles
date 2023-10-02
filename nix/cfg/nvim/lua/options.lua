-- [[ variables ]] ------------------------------------------------------
local cmd = vim.cmd
local opt = vim.opt

-- [[ imports ]] --------------------------------------------------------
local bufremove = require("mini.bufremove")
local hicursorword = require("mini.cursorword")
local indentscope = require("mini.indentscope")
local pairs = require("mini.pairs")
local starter = require("mini.starter")
local statusline = require("mini.statusline")
local tabline = require("mini.tabline")

-- [[ options ]] --------------------------------------------------------
-- syntax
opt.syntax = "on"

-- file type plugin
cmd("filetype plugin on")

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation
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
opt.hlsearch = false

-- config cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = { "indent", "eol", "start" }

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- disable backup files
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- save undo history
opt.undofile = true

-- decrease update time
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- better completion experience
opt.completeopt = { "noinsert", "menuone", "noselect" }

-- random
opt.iskeyword:append("-")

-- default terminal
opt.shell = "zsh"

-- conceal links
opt.conceallevel = 2
opt.concealcursor = "nc"

-- shell slash
opt.shellslash = true

-- [[ mini stuff ]] -----------------------------------------------------
bufremove.setup()
hicursorword.setup()
indentscope.setup()
pairs.setup()
starter.setup()
tabline.setup()
statusline.setup({ set_vim_settings = false })
