{ parameters, ... }:
{
  age.secrets = {
    "claude-service-account.json" = {
      file = ../../secrets/claude-service-account.json.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
