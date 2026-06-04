_: {
  modules.homeManager.dev.packages =
    { pkgs, osConfig, ... }:
    let
      inherit (osConfig) dotfilesLib;
    in
    {
      home.packages =
        with pkgs;
        [
          curl
          devenv
          hurl
          jdk
          jqp
          just
          lima
          nix-prefetch-github
          nodejs_latest
          opentofu
          parallel
          prek
          python314
          sqlite
        ]
        ++ (with pkgs.local; [
          diff-persist
          noctalia-settings-diff
          rename-gallery
        ]);
    };
}
