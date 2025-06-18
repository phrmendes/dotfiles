{ parameters, ... }:
{
  age.secrets = {
    docker_compose_env = {
      file = ../../secrets/docker-compose-env.age;
      path = "/etc/compose/.env";
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
