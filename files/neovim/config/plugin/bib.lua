safely("later", function()
  local has_nix, nix = pcall(require, "nix.neovim")

  if has_nix then vim.g.sqlite_clib_path = nix.sqlite end

  require("bib").setup()
end)
