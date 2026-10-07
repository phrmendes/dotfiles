{ pkgs }:
{
  caddy = pkgs.callPackage ./caddy.nix { };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp = pkgs.callPackage ./gcp.nix { };
  keepassxc = pkgs.callPackage ./keepassxc.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nushell = pkgs.callPackage ./nushell.nix { };
  pyzotero = pkgs.callPackage ./pyzotero.nix { };
}
