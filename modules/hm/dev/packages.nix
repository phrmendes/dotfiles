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
          elixir
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
          uv
          (dotfilesLib.mkGoogleCloudSdk google-cloud-sdk)
        ]
        ++ (with pkgs.local; [
          diff-persist
          noctalia-settings-diff
          rename-gallery
        ]);
    };
}
