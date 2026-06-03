{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.impermanence = {
    environment.persistence."/persist" = {
      directories = [ "/srv" ];
      users.${settings.user}.directories = [
        ".ssh"
        "dotfiles"
      ];
    };
  };
}
