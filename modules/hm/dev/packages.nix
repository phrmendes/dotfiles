_: {
  modules.homeManager.dev.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          bws
          devenv
          docker-compose
          jdk
          jqp
          just
          lima
          nix-prefetch-github
          parallel
          pass
        ]
        ++ (with pkgs.local; [
          diff-persist
          noctalia-settings-diff
        ]);
    };
}
