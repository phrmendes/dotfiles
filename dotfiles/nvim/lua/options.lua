-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

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
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

-- default terminal
vim.opt.shell = "zsh"

-- preview substitutions live
vim.opt.inccommand = "split"

-- conceal
vim.opt.conceallevel = 2

-- fold
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- clipboard
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("utils").paste,
			["*"] = require("utils").paste,
		},
	}
end

-- treat '-' as part of a word
vim.cmd([[set iskeyword+=-]])

-- nvim remote
if vim.fn.executable("nvr") then vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'" end

-- add filetypes
vim.filetype.add({
	filename = {
		["todo.txt"] = "todotxt",
		["done.txt"] = "todotxt",
	},
	pattern = {
		["*/.kube/config"] = "yaml",
		["*/.envrc"] = "sh",
	},
	extension = {
		["http"] = "http",
		["tf"] = "terraform",
	},
})

-- spell
vim.opt.spell = false

-- neovide
if vim.g.neovide then
	vim.g.neovide_padding_top = 5
	vim.g.neovide_padding_bottom = 5
	vim.g.neovide_padding_right = 5
	vim.g.neovide_padding_left = 5
end

-- hover
vim.opt.winborder = require("utils").border

-- diagnostics
vim.diagnostic.config({
	severity_sort = true,
	virtual_lines = true,
	underline = false,
	float = { border = require("utils").border },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
})
