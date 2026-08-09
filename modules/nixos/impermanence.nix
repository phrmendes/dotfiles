{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.impermanence = {
    environment.persistence."/persist" = {
      directories = [ "/srv" ];
      users.${settings.user}.directories = [
        ".ssh"
        "dotfiles"
      ];
    };
  };
}
