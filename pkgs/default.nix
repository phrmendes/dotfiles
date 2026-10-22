{ pkgs, inputs }:
let
  nuLib = pkgs.writeTextDir "lib.nu" (builtins.readFile ../files/scripts/lib.nu);
  writeNuBin =
    name:
    pkgs.writers.makeScriptWriter {
      interpreter = "${pkgs.coreutils}/bin/env -S NU_LIB_DIRS=${nuLib} ${pkgs.lib.getExe pkgs.nushell} --no-config-file";
    } "/bin/${name}";
in
{
  backup-sqlite = pkgs.callPackage ./backup-sqlite.nix { inherit writeNuBin; };
  beszel = pkgs.callPackage ./beszel.nix { src = inputs.beszel; };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp = pkgs.callPackage ./gcp.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nushell = pkgs.callPackage ./nushell.nix { };
  pyzotero = pkgs.callPackage ./pyzotero.nix { };
  vpn = pkgs.callPackage ./vpn.nix { };
}
