_: {
  modules.homeManager.dev.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          bws
          curl
          devenv
          docker-compose
          docker-credential-helpers
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
          typst
        ]
        ++ (with pkgs.local; [
          diff-persist
          noctalia-settings-diff
          rename-gallery
        ]);
    };
}
