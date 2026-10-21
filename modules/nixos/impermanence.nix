{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.impermanence = {
    environment.persistence."/persist" = {
      users.${settings.user}.directories = [
        ".ssh"
        "dotfiles"
      ];
    };
  };
}
