{ parameters, ... }:
{
  age.secrets = {
    "docker-compose.env" = {
      file = ../../secrets/docker-compose.env.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "transmission.json" = {
      file = ../../secrets/transmission.json.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "dozzle-users.yaml" = {
      file = ../../secrets/dozzle-users.yaml.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
