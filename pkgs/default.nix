{ pkgs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  tt = pkgs.callPackage ./tt.nix { };
}
