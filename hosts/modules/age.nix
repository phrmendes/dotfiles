{ parameters, ... }:
{
  age = {
    identityPaths = [ "${parameters.home}/.ssh/id_ed25519" ];
    secrets = {
      tailscale-authkey.file = ../../secrets/tailscale-authkey.age;
    };
  };
}
