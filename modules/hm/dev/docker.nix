_: {
  modules.homeManager.dev.docker =
    { pkgs, osConfig, ... }:
    {
      home.packages =
        with pkgs;
        [
          docker-buildx
          docker-compose
        ]
        ++ lib.optionals osConfig.machine.isWorkstation [ docker-credential-helpers ];

      programs.docker-cli = {
        enable = true;
        settings = if osConfig.machine.isWorkstation then { credsStore = "secretservice"; } else { };
      };
    };
}
