safely(
  "filetype:lua",
  function()
    require("lazydev").setup({
      library = {
        { path = "mini.nvim" },
        { path = require("nix.neovim").hyprland, words = { "hl%." } },
        { path = require("nix.neovim").luvit_meta, words = { "vim%.uv" } },
        { vim.fs.joinpath(vim.env.HOME, ".config", "dotfiles", "files", "neovim", "config", "lua") },
      },
    })
  end
)
