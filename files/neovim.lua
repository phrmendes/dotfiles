vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.termguicolors = true
vim.opt.confirm = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldenable = false
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

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
        ["+"] = function() return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
        ["*"] = function() return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
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

for _, name in ipairs({ "gzip", "matchit", "netrw", "netrwPlugin", "tar", "tarPlugin", "zip", "zipPlugin", "tutor" }) do
  vim.g["loaded_" .. name] = true
end

local augroup = vim.api.nvim_create_augroup

local line_numbers = augroup("LineNumbers", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = line_numbers,
  command = "if &nu && mode() != 'i' | set rnu | endif",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = line_numbers,
  command = "if &nu | set nornu | endif",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("Windows", {}),
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("FormatOptions", {}),
  pattern = "*",
  callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("TransientBuffers", {}),
  pattern = { "diff", "git", "help", "man", "qf", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup("Autoread", {}),
  callback = function()
    if vim.fn.mode() ~= "c" then vim.cmd.checktime() end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("Treesitter", {}),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match) or event.match
    if not vim.treesitter.language.add(lang) then return end
    vim.treesitter.start(event.buf, lang)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("AutoRoot", {}),
  callback = vim.schedule_wrap(function(data)
    if data.buf ~= vim.api.nvim_get_current_buf() then return end
    local root = vim.fs.root(data.buf, { ".git" })
    if root then vim.fn.chdir(root) end
  end),
})

vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Split (H)" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split (V)" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Explorer" })
vim.keymap.set("n", "<leader>p", function()
  local root = vim.fs.joinpath(vim.env.HOME, "Projects")
  local dirs = vim.fn.systemlist({ "fd", "--type", "d", "--hidden", "--no-ignore", "--max-depth", "3", "--glob", ".git", root })
  local items = vim.iter(dirs):map(function(d) return vim.fs.dirname(d) end):totable()
  vim.ui.select(items, { prompt = "Project" }, function(choice)
    if choice then vim.fn.chdir(choice) end
  end)
end, { desc = "Projects" })
vim.keymap.set("n", "<leader><leader>", function() vim.fn.feedkeys(":find **/*", "n") end, { desc = "Find file" })
vim.keymap.set("n", "<leader>/", function() vim.fn.feedkeys(":silent grep  | copen\18", "n") end, { desc = "Grep" })
vim.keymap.set("n", "<c-p>", "<cmd>buffers<cr>:b<space>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>zz", { desc = "Prev quickfix" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>gs", function() vim.cmd("terminal git status") end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>vertical Git diff<cr>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gl", function() vim.cmd("terminal git log --oneline --graph --decorate -20") end, { desc = "Git log" })
vim.keymap.set("n", "<leader>gD", function() vim.cmd("windo diffthis") end, { desc = "Diff windows" })
vim.keymap.set("n", "<leader>gO", "<cmd>diffoff!<cr>", { desc = "Diff off" })
vim.keymap.set("n", "]c", "]czz", { desc = "Next hunk" })
vim.keymap.set("n", "[c", "[czz", { desc = "Prev hunk" })
