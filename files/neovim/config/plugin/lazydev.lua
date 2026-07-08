safely(
  "filetype:lua",
  function()
    require("lazydev").setup({
      library = {
        { path = "mini.nvim" },
        { path = require("nix.neovim").hyprland_stubs, words = { "hl%." } },
        { path = require("nix.neovim").luvit_meta, words = { "vim%.uv" } },
        { vim.fs.joinpath(vim.env.HOME, "Projects", "dotfiles", "dotfiles", "nvim", "lua") },
      },
    })
  end
)
