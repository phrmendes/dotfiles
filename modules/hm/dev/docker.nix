_: {
  modules.homeManager.dev.docker =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        docker-buildx
        docker-compose
        docker-credential-helpers
      ];

      programs.docker-cli = {
        enable = true;
        settings.credsStore = "secretservice";
      };
    };
}
