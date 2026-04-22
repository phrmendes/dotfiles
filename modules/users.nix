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
        isWorkstation = config.machine.type != "server";
      in
      {
        users = {
          mutableUsers = true;
          users = {
            ${settings.user} = {
              home = settings.home;
              shell = pkgs.zsh;
              initialPassword = "password";
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
      home.file =
        let
          scripts = ../files/scripts |> builtins.readDir |> builtins.attrNames;
          executables =
            scripts
            |> map (name: {
              name = ".local/bin/${name}" |> builtins.replaceStrings [ ".sh" ] [ "" ];
              value = {
                executable = true;
                source = ../files/scripts/${name};
              };
            })
            |> builtins.listToAttrs;
        in
        {
          ".face.icon".source = ../files/face.png;
        }
        // executables;
    };
  };
}
