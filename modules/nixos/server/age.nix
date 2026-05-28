_: {
  modules.nixos.server.age = _: {
    age.secrets = {
      "beszel.env" = {
        file = ../../../secrets/beszel.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "bifrost.env" = {
        file = ../../../secrets/bifrost.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "cloudflare.env" = {
        file = ../../../secrets/cloudflare.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "linkding.env" = {
        file = ../../../secrets/linkding.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "litestream.env" = {
        file = ../../../secrets/litestream.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "telegram.env" = {
        file = ../../../secrets/telegram.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "duplicati.env" = {
        file = ../../../secrets/duplicati.age.env;
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "transmission.json" = {
        file = ../../../secrets/transmission.age.json;
        mode = "0400";
        owner = "root";
        group = "root";
      };
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
