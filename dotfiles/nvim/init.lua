local nix_path = vim.fs.joinpath(vim.fn.stdpath("data"), "nix")
local dev_paths = require("helpers").get_subdirectories(vim.fs.joinpath(vim.env.HOME, "Projects", "vim-plugins"))
local paths = vim.iter({ nix_path, dev_paths }):flatten():totable()

vim.iter(paths):each(function(path) vim.opt.rtp:prepend(path) end)

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.deps").setup()

_G.now = require("mini.deps").now
_G.later = require("mini.deps").later

require("options")
require("autocmds")
require("keymaps")
