safely("later", function()
  vim.g.sqlite_clib_path = require("nix.neovim").sqlite
  require("bib").setup()
end)
