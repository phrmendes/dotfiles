{ pkgs }:
{
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  rename-gallery = pkgs.callPackage ./rename-gallery.nix { };
  screenshot = pkgs.callPackage ./screenshot.nix { };
  tt = pkgs.callPackage ./tt.nix { };
}
