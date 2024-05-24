-- leader keys
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]

-- syntax
vim.opt.syntax = "on"

-- file type plugin
vim.cmd([[filetype plugin on]])

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- tabs and indentation
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.shiftwidth = 4
vim.opt.showtabline = 1
vim.opt.tabstop = 4
vim.opt.wrap = true

-- line wrapping
vim.opt.wrap = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- config cursor line
vim.opt.cursorline = true

-- appearance
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- backspace
vim.opt.backspace = { "indent", "eol", "start" }

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- disable backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- save undo history
vim.opt.undofile = true

-- decrease update time
vim.opt.updatetime = 200
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- better completion experience
vim.opt.completeopt = { "noinsert", "menuone", "noselect" }

-- random
vim.opt.iskeyword:append("-")

-- default terminal
vim.opt.shell = "zsh"

-- preview substitutions live
vim.opt.inccommand = "split"

-- conceal
vim.opt.conceallevel = 2

-- clipboard
vim.opt.clipboard:append({ "unnamedplus" })

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- mouse support
vim.g.VM_mouse_mappings = 1

-- language
vim.cmd([[language en_US.UTF-8]])

-- treat '-' as part of a word
vim.cmd([[set iskeyword+=-]])

-- filetypes
vim.filetype.add({
	extension = { http = "http" },
})

-- nvim server
if vim.fn.executable("nvr") then
	vim.env.EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
	vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
	vim.env.VISUAL = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

-- neovide
if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font Mono:h14"
	vim.g.neovide_padding_top = 5
	vim.g.neovide_padding_bottom = 5
	vim.g.neovide_padding_right = 5
	vim.g.neovide_padding_left = 5
end
