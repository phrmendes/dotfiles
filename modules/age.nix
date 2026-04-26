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
          "claude-service-account.json" = secret ../secrets/claude-service-account.json.age "0444";
          "opencode.txt" = secret' ../secrets/opencode.txt.age;
        };
      };
    };

    server.age = {
      imports = [ inputs.agenix.nixosModules.default ];
      age = {
        secrets = {
          "docker-compose.env" = secret' ../secrets/docker-compose.env.age;
          "docker-config.json" = secret ../secrets/docker-config.json.age "0400";
          "dozzle-users.yaml" = secret' ../secrets/dozzle-users.yaml.age;
          "gh-hosts.yaml" = secret ../secrets/gh-hosts.yaml.age "0400";
          "prunemate.json" = secret ../secrets/prunemate.json.age "0444";
          "transmission.json" = secret' ../secrets/transmission.json.age;
        };
      };
    };
  };
}
