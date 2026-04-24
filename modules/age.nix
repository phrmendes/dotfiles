{ config, inputs, ... }:
let
  inherit (config) settings;
  secret = file: mode: {
    inherit file mode;
    owner = settings.user;
    group = "users";
  };
  secret' = file: secret file "0440";
in
{
  modules.nixos = {
    core.age = {
      imports = [ inputs.agenix.nixosModules.default ];
      age = {
        identityPaths = [ "/persist${settings.home}/.ssh/age" ];
        secrets = {
          "opencode-go-key.txt" = secret ../secrets/opencode-go-key.txt.age "0444";
          "tailscale-authkey".file = ../secrets/tailscale-authkey.age;
        };
      };
    };

    server.age = {
      imports = [ inputs.agenix.nixosModules.default ];
      age = {
        secrets = {
          "docker-config.json" = secret ../secrets/docker-config.json.age "0400";
          "gh-hosts.yaml" = secret ../secrets/gh-hosts.yaml.age "0400";
          "docker-compose.env" = secret' ../secrets/docker-compose.env.age;
          "dozzle-users.yaml" = secret' ../secrets/dozzle-users.yaml.age;
          "prunemate.json" = secret' ../secrets/prunemate.json.age;
          "transmission.json" = secret' ../secrets/transmission.json.age;
        };
      };
    };
  };
}
