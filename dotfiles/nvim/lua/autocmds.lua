local augroups = {
  line_numbers = vim.api.nvim_create_augroup("UserLineNumbers", {}),
  transient_buffers = vim.api.nvim_create_augroup("UserTransientBuffers", {}),
  format_options = vim.api.nvim_create_augroup("UserFormatOptions", {}),
  yank = vim.api.nvim_create_augroup("UserYank", {}),
  windows = vim.api.nvim_create_augroup("UserWindows", {}),
  treesitter = vim.api.nvim_create_augroup("UserTreesitter", {}),
}

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and folding",
  group = augroups.treesitter,
  callback = function(event)
    local language = vim.treesitter.language.get_lang(event.match) or event.match

    if not vim.treesitter.language.add(language) then return end

    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.treesitter.start(event.buf, language)
    vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  desc = "Automatically close Vim if the quickfix window is the only one open",
  group = augroups.windows,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.fn.win_gettype() == "quickfix" then vim.cmd.q() end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroups.yank,
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Make transient buffers closable with q",
  group = augroups.transient_buffers,
  pattern = { "dap-float", "dap-repl", "dap-view", "dap-view-term", "diff", "git", "help", "man", "qf", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  desc = "Enable relative line numbers in normal mode",
  group = augroups.line_numbers,
  pattern = "*",
  command = "if &nu && mode() != 'i' | set rnu | endif",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  desc = "Disable relative line numbers when leaving window or entering insert mode",
  group = augroups.line_numbers,
  pattern = "*",
  command = "if &nu | set nornu | endif",
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Equalize window sizes after resizing Vim",
  group = augroups.windows,
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable automatic comment continuation on new lines",
  group = augroups.format_options,
  pattern = "*",
  callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Set shiftwidth to 2 for specific filetypes",
  pattern = { "json", "lua", "markdown", "nix", "sql", "terraform" },
  callback = function() vim.opt_local.shiftwidth = 2 end,
})
