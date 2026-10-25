vim.pack.add({
  "https://codeberg.org/mfussenegger/nvim-ansible",
  "https://forge.barrettruth.com/barrettruth/diffs.nvim",
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/Saecki/crates.nvim",
  "https://github.com/TheNoeTrevino/haunt.nvim",
  "https://github.com/ThePrimeagen/refactoring.nvim",
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/sidekick.nvim",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/jpalardy/vim-slime",
  "https://github.com/julianolf/nvim-dap-lldb",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/kkharji/sqlite.lua",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/lewis6991/async.nvim",
  "https://github.com/m00qek/baleia.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-dap-python",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/phrmendes/bib.nvim",
  "https://github.com/phrmendes/notes.nvim",
  "https://github.com/phrmendes/todotxt.nvim",
  "https://github.com/qvalentin/helm-ls.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/ravsii/tree-sitter-d2",
  "https://github.com/smart-splits-nvim/backend-kitty",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/tadmccorkle/markdown.nvim",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/waiting-for-dev/ergoterm.nvim",
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "tree-sitter-d2" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("tree-sitter-d2") end
      vim.system({ "make", "nvim-install" }, { cwd = ev.data.path })
    end
  end,
})

require("mini.misc").setup()

_G.safely = require("mini.misc").safely

require("options")
require("autocmds")
require("lsp")
require("keymaps")
