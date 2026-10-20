{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.impermanence = {
    environment.persistence."/persist" = {
      users.${settings.user}.directories = [
        ".ssh"
        "dotfiles"
      ];
    };
  };
}
