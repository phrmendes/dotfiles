safely(
  "filetype:lua",
  function()
    require("lazydev").setup({
      library = {
        { path = require("nix.neovim").luvit_meta, words = { "vim%.uv" } },
        { path = require("nix.neovim").hyprland_stubs, words = { "hl%." } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { vim.fs.joinpath(vim.env.HOME, "Projects", "dotfiles", "dotfiles", "nvim", "lua") },
      },
    })
  end
)
