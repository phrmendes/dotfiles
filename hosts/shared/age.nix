{ parameters, ... }:
{
  age = {
    identityPaths = [ "/persist/${parameters.home}/.ssh/id_ed25519" ];
    secrets = {
      tailscale-authkey.file = ../../secrets/tailscale-authkey.age;
      hashed-password.file = ../../secrets/hashed-password.age;
    };
  };
}
