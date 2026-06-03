{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.persistence = {
    environment.persistence."/persist" = {
      directories = [ "/srv" ];
      users.${settings.user}.directories = [
        ".ssh"
        "dotfiles"
      ];
    };
  };
}
