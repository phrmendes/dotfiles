{ pkgs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  neovim = pkgs.callPackage ./neovim.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
}
