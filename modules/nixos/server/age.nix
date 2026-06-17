{ config, ... }:
{
  modules.nixos.server.age =
    _:
    let
      inherit (config.dotfilesLib) mkSecretReadable;
      secretReadable =
        args:
        mkSecretReadable (
          {
            user = "root";
            group = "root";
            mode = "0400";
          }
          // args
        );
    in
    {
      age.secrets = {
        "beszel.env" = secretReadable { file = ../../../secrets/beszel.age.env; };
        "cloudflare.env" = secretReadable { file = ../../../secrets/cloudflare.age.env; };
        "linkding.env" = secretReadable { file = ../../../secrets/linkding.age.env; };
        "litestream.env" = secretReadable { file = ../../../secrets/litestream.age.env; };
        "telegram.env" = secretReadable { file = ../../../secrets/telegram.age.env; };
        "duplicati.env" = secretReadable { file = ../../../secrets/duplicati.age.env; };
        "transmission.json" = secretReadable { file = ../../../secrets/transmission.age.json; };
        "dockerhub.json" = secretReadable {
          file = ../../../secrets/dockerhub.age.json;
          path = "/root/.docker/config.json";
        };
      };
    };
}
