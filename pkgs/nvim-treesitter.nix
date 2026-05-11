{
  lib,
  lndir,
  runCommandLocal,
  vimPlugins,
}:
let
  inherit (vimPlugins)
    nvim-treesitter
    nvim-treesitter-parsers
    nvim-treesitter-textobjects
    ;
in
let
  parsers = nvim-treesitter-parsers |> builtins.attrValues |> builtins.filter lib.isDerivation;
  queries = runCommandLocal "nvim-treesitter-queries" { nativeBuildInputs = [ lndir ]; } ''
    mkdir -p $out/queries
    lndir -silent ${nvim-treesitter}/runtime/queries $out/queries
    lndir -silent ${nvim-treesitter-textobjects}/queries $out/queries
  '';
in
parsers ++ [ queries ]
