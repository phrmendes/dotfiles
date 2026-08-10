{ pkgs }:
{
  caddy = pkgs.callPackage ./caddy.nix { };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
}
