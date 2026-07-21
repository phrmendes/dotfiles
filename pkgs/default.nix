{ pkgs, inputs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  neovim = pkgs.callPackage ./neovim.nix { };
  grafito = pkgs.callPackage ./grafito.nix { src = inputs.grafito; };
}
