{ parameters, ... }:
{
  age.secrets = {
    docker-compose-env.file = ../../secrets/docker-compose-env.age;
    server-password = {
      file = ../../secrets/server-password.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
