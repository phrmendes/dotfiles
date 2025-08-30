vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }
vim.opt.cursorline = true
vim.opt.cursorlineopt = "screenline"
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.wrap = true
vim.opt.writebackup = false

if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = function()
				return {
					vim.fn.split(vim.fn.getreg(""), "\n"),
					vim.fn.getregtype(""),
				}
			end,
			["*"] = function()
				return {
					vim.fn.split(vim.fn.getreg(""), "\n"),
					vim.fn.getregtype(""),
				}
			end,
		},
	}
end

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>x", ":x<cr>")

vim.keymap.set("n", "<leader>q", function()
	if vim.list_contains(vim.v.argv, "--embed") then
		vim.cmd.quit()
		return
	end

	vim.cmd.detach()
end)

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>")
vim.keymap.set("n", "<leader>bb", "<cmd>buffer #<cr>")

vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>")
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>")
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>")
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>")

vim.keymap.set("n", "<leader>t", function()
	vim.ui.input({ prompt = "Name: " }, function(name)
		if name then vim.cmd("terminal fish \\# " .. name) end
	end)
end)

vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>")
vim.keymap.set("n", "]b", "<cmd>bnext<cr>")

vim.keymap.set("n", "<esc>", ":nohlsearch<cr>")
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { silent = true })
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	callback = function() vim.highlight.on_yank() end,
})
