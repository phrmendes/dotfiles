{ parameters, ... }:
{
  age.secrets = {
    tailscale_tsdproxy_key = {
      file = ../../secrets/tailscale-tsdproxy-key.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    docker_compose_env = {
      file = ../../secrets/docker-compose-env.age;
      path = "/etc/compose/.env";
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
