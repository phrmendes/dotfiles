vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.shiftround = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.foldenable = false
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 8
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.undolevels = 10000
vim.opt.autocomplete = true
vim.opt.completeopt = "menu,menuone,popup,fuzzy"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.path:append("**")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
  if vim.env.SSH_TTY then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  end
end)

vim.diagnostic.config({
  severity_sort = true,
  virtual_lines = { current_line = true },
  underline = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

for _, name in ipairs({ "gzip", "matchit", "tar", "tarPlugin", "zip", "zipPlugin", "tutor" }) do
  vim.g["loaded_" .. name] = true
end

vim.cmd.colorscheme("retrobox")

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("Windows", {}),
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TransientBuffers", {}),
  pattern = { "diff", "git", "help", "man", "qf", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("Autoread", {}),
  callback = function()
    if vim.fn.mode() ~= "c" then vim.cmd.checktime() end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("Treesitter", {}),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match) or event.match
    if not vim.treesitter.language.add(lang) then return end
    vim.treesitter.start(event.buf, lang)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", {}),
  callback = function() vim.hl.on_yank() end,
})

vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>grep! <cword><cr><cmd>copen<cr>", { desc = "Grep word" })
vim.keymap.set("n", "<leader>?", "<cmd>helpgrep ", { desc = "Help grep" })
vim.keymap.set("n", "<leader><leader>", "<cmd>find ", { desc = "Find file" })
vim.keymap.set("n", "<c-p>", "<cmd>buffer ", { desc = "Switch buffer" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Explorer" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>N", "<cmd>messages<cr>", { desc = "Messages" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>x", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
