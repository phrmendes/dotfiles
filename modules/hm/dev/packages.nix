_: {
  modules.homeManager.dev.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          bws
          docker-compose
          jdk
          jqp
          just
          lima
          nix-prefetch-github
          parallel
          pass
          tuicr
        ]
        ++ (with pkgs.local; [
          diff-persist
          noctalia-settings-diff
        ]);
    };
}
