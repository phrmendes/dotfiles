{ pkgs, inputs }:
let
  mkNushell = pkgs.callPackage ./nushell.nix { };
  nushell = mkNushell (
    with pkgs.nushellPlugins;
    [
      formats
      gstat
      polars
      query
    ]
  );
  nuLib = pkgs.writeTextDir "lib.nu" (builtins.readFile ../files/scripts/lib.nu);
  writeNuBin =
    {
      name,
      runtimeInputs ? [ ],
      plugins ? null,
    }:
    text:
    let
      shell = if plugins == null then nushell else mkNushell plugins;
      script = pkgs.writers.makeScriptWriter {
        interpreter = "${pkgs.coreutils}/bin/env -S NU_LIB_DIRS=${nuLib} ${pkgs.lib.getExe shell} --no-config-file";
      } "/bin/${name}" text;
    in
    if runtimeInputs == [ ] then
      script
    else
      pkgs.symlinkJoin {
        inherit name;
        paths = [ script ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : ${pkgs.lib.makeBinPath runtimeInputs}";
      };
in
{
  backup-sqlite = pkgs.callPackage ./backup-sqlite.nix { inherit writeNuBin; };
  beszel = pkgs.callPackage ./beszel.nix { src = inputs.beszel; };
  diff-persist = pkgs.callPackage ./diff-persist.nix { };
  gcp = pkgs.callPackage ./gcp.nix { };
  noctalia-settings-diff = pkgs.callPackage ./noctalia-settings-diff.nix { };
  nsm = inputs.nsm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  inherit nushell;
  pin = pkgs.callPackage ./pin.nix { inherit writeNuBin; };
  pyzotero = pkgs.callPackage ./pyzotero.nix { src = inputs.pyzotero; };
  screenshot = writeNuBin { name = "screenshot"; } (builtins.readFile ../files/scripts/screenshot.nu);
  restic-restore-test = writeNuBin { name = "restic-restore-test"; } (
    builtins.readFile ../files/scripts/restic-restore-test.nu
  );
  sync-repos = pkgs.callPackage ./sync-repos.nix { inherit writeNuBin; };
  vpn = pkgs.callPackage ./vpn.nix { inherit writeNuBin; };
  inherit (inputs) zj-which-key;
}
