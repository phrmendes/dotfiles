{ config, inputs, ... }:
let
  inherit (config) settings;
  secret = file: mode: {
    inherit file mode;
    owner = settings.user;
    group = "users";
  };
  secretReadable = file: secret file "0440";
in
{
  modules.nixos.core.age = {
    imports = [ inputs.agenix.nixosModules.default ];
    age = {
      identityPaths = [ "/persist${settings.home}/.ssh/age" ];
      secrets = {
        "claude-service-account.json" = secretReadable ../../../secrets/claude-service-account.json.age;
        "opencode.txt" = secretReadable ../../../secrets/opencode.txt.age;
      };
    };
  };
}
