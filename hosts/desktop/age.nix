{ parameters, ... }:
{
  age.secrets = {
    server_password = {
      file = ../../secrets/server-password.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };
}
