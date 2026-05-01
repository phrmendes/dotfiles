{ config, ... }:
let
  inherit (config) settings;
in
{
  modules = {
    nixos.core.users =
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
          users = {
            ${settings.user} = {
              home = settings.home;
              shell = pkgs.zsh;
              password = "changeme";
              openssh.authorizedKeys.keys = [
                (builtins.readFile ../files/ssh-keys/main.txt)
                (builtins.readFile ../files/ssh-keys/phone.txt)
                (builtins.readFile ../files/ssh-keys/laptop.txt)
                (builtins.readFile ../files/ssh-keys/server.txt)
              ];
              isNormalUser = true;
              uid = 1000;
              linger = true;
              extraGroups = [
                "docker"
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

    homeManager.user.symlinks = {
      home.file.".face.icon".source = ../files/face.png;

      xdg.configFile."satty/config.toml".source = ../files/satty.toml;
    };
  };
}
