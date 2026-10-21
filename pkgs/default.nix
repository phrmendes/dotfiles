{ pkgs, inputs }:
{
  beszel = pkgs.callPackage ./beszel.nix { src = inputs.beszel; };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp = pkgs.callPackage ./gcp.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nushell = pkgs.callPackage ./nushell.nix { };
  pin = pkgs.callPackage ./pin.nix { };
  pyzotero = pkgs.callPackage ./pyzotero.nix { };
  vpn = pkgs.callPackage ./vpn.nix { };
}
