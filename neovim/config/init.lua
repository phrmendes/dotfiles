vim.pack.add({
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/NickvanDyke/opencode.nvim",
  "https://github.com/ThePrimeagen/refactoring.nvim",
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
  "https://github.com/brianhuster/unnest.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/jalvesaq/zotcite",
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/jpalardy/vim-slime",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/mbbill/undotree",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-dap-python",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/qvalentin/helm-ls.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/tadmccorkle/markdown.nvim",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/tpope/vim-dadbod",
})

for name in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "local", "opt")) do
  vim.cmd.packadd(name)
end

require("mini.misc").setup()

_G.safely = require("mini.misc").safely

require("options")
require("autocmds")
require("keymaps")
require("lsp")

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    msg = { height = 0.3, timeout = 5000 },
    pager = { height = 0.5 },
  },
})
