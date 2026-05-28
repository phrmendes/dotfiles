{ config, ... }:
let
  inherit (config) settings dotfilesLib;
in
{
  modules.nixos.server.age =
    _:
    let
      secretReadable = dotfilesLib.mkSecretReadable settings.user;
    in
    {
      age.secrets = {
        "beszel.env" = secretReadable ../../../secrets/beszel.age.env;
        "cloudflare.env" = secretReadable ../../../secrets/cloudflare.age.env;
        "linkding.env" = secretReadable ../../../secrets/linkding.age.env;
        "litestream.env" = secretReadable ../../../secrets/litestream.age.env;
        "telegram.env" = secretReadable ../../../secrets/telegram.age.env;
        "duplicati.env" = secretReadable ../../../secrets/duplicati.age.env;
        "qbittorrent.env" = secretReadable ../../../secrets/qbittorrent.age.env;
        "dockerhub.json" = {
          file = ../../../secrets/dockerhub.age.json;
          path = "/root/.docker/config.json";
          mode = "0400";
          owner = "root";
          group = "root";
        };
      };
    };
}
