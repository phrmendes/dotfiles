safely("filetype:lua", function()
  local has_nix, nix = pcall(require, "nix.neovim")

  local library = {
    { path = "mini.nvim" },
    { vim.fs.joinpath(vim.env.HOME, ".config", "dotfiles", "files", "neovim", "config", "lua") },
  }

  if has_nix and nix.luvit_meta then table.insert(library, { path = nix.luvit_meta, words = { "vim%.uv" } }) end

  require("lazydev").setup({ library = library })
end)
