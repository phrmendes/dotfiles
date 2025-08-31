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
    "gotify-server-upgrade-token" = {
      file = ../../secrets/gotify-server-upgrade-token.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
    "gotify-fail2ban-token" = {
      file = ../../secrets/gotify-fail2ban-token.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
