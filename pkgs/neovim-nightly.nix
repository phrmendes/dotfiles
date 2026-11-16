{
  writeShellScriptBin,
  neovim,
}:
writeShellScriptBin "nvim-nightly" ''
  exec ${neovim}/bin/nvim "$@"
''
