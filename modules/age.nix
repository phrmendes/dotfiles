{ config, ... }:
let
  inherit (config) settings;
  secret = file: {
    inherit file;
    owner = settings.user;
    group = "users";
    mode = "0440";
  };
  dockerSecret = file: (secret file) // { mode = "0444"; };
in
{
  modules.nixos = {
    core.age = {
      age = {
        identityPaths = [ "/persist${settings.home}/.ssh/age" ];
        secrets = {
          "claude-service-account.json" = secret ../secrets/claude-service-account.json.age;
          "litellm.env" = secret ../secrets/litellm.env.age;
          "tailscale-authkey".file = ../secrets/tailscale-authkey.age;
        };
      };
    };

    server.secrets = {
      age.secrets = {
        "docker-compose.env" = secret ../secrets/docker-compose.env.age;
        "dozzle-users.yaml" = dockerSecret ../secrets/dozzle-users.yaml.age;
        "prunemate.json" = dockerSecret ../secrets/prunemate.json.age;
        "transmission.json" = dockerSecret ../secrets/transmission.json.age;
      };
    };
  };
}
