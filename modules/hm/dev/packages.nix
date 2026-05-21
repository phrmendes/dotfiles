_: {
  modules.homeManager.dev.packages =
    { pkgs, dotfilesLib, ... }:
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
          gcp-token
          noctalia-settings-diff
          rename-gallery
        ]);
    };
}
