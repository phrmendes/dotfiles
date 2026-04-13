{ config, ... }:
let
  secret = file: {
    inherit file;
    owner = config.settings.user;
    group = "users";
    mode = "0440";
  };
in
{
  modules.nixos = {
    core.age = {
      age = {
        identityPaths = [ "${config.settings.home}/.ssh/age" ];
        secrets.tailscale-authkey.file = ../secrets/tailscale-authkey.age;
      };
    };

    workstation.secrets = {
      age.secrets."claude-service-account.json" = secret ../secrets/claude-service-account.json.age;
    };

    server.secrets = {
      age.secrets = {
        "docker-compose.env" = secret ../secrets/docker-compose.env.age;
        "transmission.json" = secret ../secrets/transmission.json.age;
        "prunemate.json" = secret ../secrets/prunemate.json.age;
        "dozzle-users.yaml" = secret ../secrets/dozzle-users.yaml.age;
      };
    };
  };
}
