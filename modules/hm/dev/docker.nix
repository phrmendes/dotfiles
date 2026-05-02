_: {
  modules.homeManager.dev.docker =
    { pkgs, osConfig, ... }:
    {
      home.packages = with pkgs; [
        docker-buildx
        docker-compose
      ];

      programs.docker-cli = {
        enable = true;
        settings.credsStore = if osConfig.machine.isWorkstation then "secretservice" else "";
      };
    };
}
