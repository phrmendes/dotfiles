{ config, ... }:
let
  inherit (config) settings;
  secret = file: mode: {
    inherit file mode;
    owner = settings.user;
    group = "users";
  };
  secretReadable = file: secret file "0440";
in
{
  modules.nixos.server.age = {
    age.secrets = {
      "docker-compose.env" = secretReadable ../../../secrets/docker-compose.env.age;
      "docker-config.json" = secret ../../../secrets/docker-config.json.age "0400";
      "dozzle-users.yaml" = secretReadable ../../../secrets/dozzle-users.yaml.age;
      "gh-hosts.yaml" = secret ../../../secrets/gh-hosts.yaml.age "0400";
      "prunemate.json" = secret ../../../secrets/prunemate.json.age "0444";
      "transmission.json" = secretReadable ../../../secrets/transmission.json.age;
    };
  };
}
