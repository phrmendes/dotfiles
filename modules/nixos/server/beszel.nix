_: {
  modules.nixos.server.beszel =
    { config, ... }:
    {
      services.beszel.agent = {
        enable = true;
        environmentFile = config.age.secrets."beszel-agent.env".path;
        environment = {
          HUB_URL = "http://localhost:8090";
          DOCKER_HOST = "tcp://localhost:2375";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIR9/sS1/jqtENlx6ljeHtwJm8xI2Z3vMtQpTl0YThS";
        };
        smartmon = {
          enable = true;
          deviceAllow = [
            "/dev/sda"
            "/dev/sdc"
          ];
        };
      };
    };
}
