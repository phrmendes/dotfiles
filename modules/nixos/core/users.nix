{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.users =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (config.machine) isWorkstation;
    in
    {
      users = {
        mutableUsers = true;
        groups.external = { };
        users = {
          ${settings.user} = {
            inherit (settings) home;
            shell = pkgs.zsh;
            password = "changeme";
            openssh.authorizedKeys.keys = [
              (builtins.readFile ../../../files/ssh-keys/main.txt)
              (builtins.readFile ../../../files/ssh-keys/phone.txt)
              (builtins.readFile ../../../files/ssh-keys/laptop.txt)
              (builtins.readFile ../../../files/ssh-keys/server.txt)
            ];
            isNormalUser = true;
            uid = 1000;
            linger = true;
            extraGroups = [
              "external"
              "keys"
              "networkmanager"
              "wheel"
            ]
            ++ lib.optionals isWorkstation [
              "adbusers"
              "audio"
              "libvirtd"
              "video"
            ];
          };
        };
      };
    };
}
