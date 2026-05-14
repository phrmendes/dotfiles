-- leader keys (must be set before any <leader> mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- enable true color support unconditionally (needed for correct remote-ui colors)
vim.opt.termguicolors = true

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
vim.opt.splitbelow = true
vim.opt.splitright = true

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
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
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

if vim.g.neovide then
  vim.g.neovide_theme = "dark"
  vim.g.neovide_hide_mouse_when_typing = true

  -- padding
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_left = 10
  vim.g.neovide_padding_right = 10

  -- scroll animation
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_scroll_animation_far_lines = 0

  -- cursor animation
  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_cursor_short_animation_length = 0.02
  vim.g.neovide_cursor_trail_size = 0.4
  vim.g.neovide_cursor_animate_in_insert_mode = false
end
