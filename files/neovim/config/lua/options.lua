-- leader keys (must be set before any <leader> mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- confirm before operations in files with unsaved changes
vim.opt.confirm = true

-- overrides for mini.basics defaults
vim.opt.wrap = true
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }
vim.opt.cursorlineopt = "screenline"
vim.opt.listchars:append({ tab = "▏ " })

-- tabs and indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- disable swap files
vim.opt.swapfile = false

-- decrease update time
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- default terminal
vim.opt.shell = "zsh"

-- fold
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
      ["+"] = require("helpers").paste,
      ["*"] = require("helpers").paste,
    },
  }
end

-- treat '-' as part of a word
vim.opt.iskeyword:append("-")

-- add filetypes
vim.filetype.add({
  filename = {
    ["todo.txt"] = "todotxt",
    ["done.txt"] = "todotxt",
    ["Caddyfile"] = "caddy",
    ["kubeconfig"] = "yaml",
    [".envrc"] = "sh",
    [".env"] = "dosini",
  },
  pattern = {
    ["*/.kube/config"] = "yaml",
  },
  extension = {
    http = "http",
    tf = "terraform",
    dump = "log",
  },
})

-- border
vim.g.border = "rounded"
vim.opt.winborder = vim.g.border

-- diagnostics
vim.diagnostic.config({
  severity_sort = true,
  virtual_lines = { current_line = true },
  underline = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
})

-- popup menu
vim.opt.pumborder = vim.g.border

-- incremental command preview
vim.opt.inccommand = "split"

-- disable builtin plugins
local plugins = {
  "gzip",
  "matchit",
  "netrw",
  "netrwFileHandlers",
  "netrwPlugin",
  "netrwSettings",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "zip",
  "zipPlugin",
  "tutor",
}

vim.iter(plugins):each(function(plugin) vim.g["loaded_" .. plugin] = true end)
