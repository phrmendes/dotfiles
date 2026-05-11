_: {
  modules.homeManager.dev.docker =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    let
      hasDockerSecret = osConfig.age.secrets ? "docker-config.json";
      dockerConfigSecret = osConfig.age.secrets."docker-config.json".path;
    in
    {
      home.packages =
        with pkgs;
        [
          docker-buildx
          docker-compose
        ]
        ++ lib.optionals osConfig.machine.isWorkstation [ docker-credential-helpers ];

      programs.docker-cli = {
        enable = !hasDockerSecret;
        settings = lib.mkIf (!hasDockerSecret && osConfig.machine.isWorkstation) {
          credsStore = "secretservice";
        };
      };

      systemd.user.tmpfiles.rules = lib.mkIf hasDockerSecret [
        "L+ %h/.docker/config.json - - - - ${dockerConfigSecret}"
      ];
    };
}
