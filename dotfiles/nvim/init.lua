local nix_path = vim.fs.joinpath(vim.fn.stdpath("data"), "nix")
local dev_path = require("helpers").get_subdirectories(vim.fs.joinpath(vim.env.HOME, "Projects", "vim-plugins"))
local paths = vim.iter({ nix_path, dev_path }):flatten():totable()

vim.iter(paths):each(function(path) vim.opt.rtp:prepend(path) end)

vim.pack.add({
  "https://github.com/Allaman/tf.nvim",
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/NickvanDyke/opencode.nvim",
  "https://github.com/ThePrimeagen/refactoring.nvim",
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
  "https://github.com/brianhuster/unnest.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/jpalardy/vim-slime",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/mbbill/undotree",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-dap-python",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/mistweaverco/kulala.nvim",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/qvalentin/helm-ls.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/tadmccorkle/markdown.nvim",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/tpope/vim-dadbod",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", name = "ts" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

require("mini.misc").setup()

_G.safely = require("mini.misc").safely

require("options")
require("autocmds")
require("keymaps")
require("lsp")
