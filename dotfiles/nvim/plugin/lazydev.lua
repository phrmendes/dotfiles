now(
  function()
    require("lazydev").setup({
      library = {
        { path = require("nix.luvit-meta"), words = { "vim%.uv" } },
        { vim.fs.joinpath(vim.env.HOME, "Projects", "dotfiles", "dotfiles", "nvim", "lua") },
      },
    })
  end
)
