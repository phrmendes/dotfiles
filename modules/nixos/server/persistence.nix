{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.persistence = {
    environment.persistence."/persist".users.${settings.user}.directories = [
      "dotfiles"
      ".config"
      ".ssh"
      ".local/share"
      ".local/state"
    ];
  };
}
