{
  lib,
  lndir,
  runCommandLocal,
  vimPlugins,
  vimUtils,
}:
let
  inherit (vimPlugins)
    nvim-treesitter
    nvim-treesitter-parsers
    nvim-treesitter-textobjects
    ;
  parsers = nvim-treesitter-parsers |> builtins.attrValues |> builtins.filter lib.isDerivation;
  queries = vimUtils.buildVimPlugin {
    pname = "nvim-treesitter-queries";
    inherit (nvim-treesitter) version;
    src = runCommandLocal "nvim-treesitter-queries-src" { nativeBuildInputs = [ lndir ]; } ''
      mkdir -p $out/queries
      lndir -silent ${nvim-treesitter}/runtime/queries $out/queries
      lndir -silent ${nvim-treesitter-textobjects}/queries $out/queries
    '';
  };
in
lib.flatten [
  parsers
  queries
]
