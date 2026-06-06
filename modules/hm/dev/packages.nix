_: {
  modules.homeManager.dev.packages =
    { pkgs, ... }:
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
          parallel
          pass
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
