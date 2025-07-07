{ parameters, ... }:
{
  age.secrets = {
    "docker-compose.env" = {
      file = ../../secrets/docker-compose.env.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
