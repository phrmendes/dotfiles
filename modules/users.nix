{ config, ... }:
{
  modules = {
    nixos.core.users =
      { pkgs, ... }:
      {
        users = {
          mutableUsers = true;
          users = {
            ${config.settings.user} = {
              home = config.settings.home;
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
              extraGroups = [
                "adbusers"
                "audio"
                "docker"
                "libvirtd"
                "networkmanager"
                "video"
                "wheel"
              ];
            };
          };
        };
      };

    homeManager.user.symlinks = {
      home.file =
        let
          scripts = ../files/scripts |> builtins.readDir |> builtins.attrNames;
          executables = builtins.listToAttrs (
            map (name: {
              name = ".local/bin/${name}" |> builtins.replaceStrings [ ".sh" ] [ "" ];
              value = {
                executable = true;
                source = ../files/scripts/${name};
              };
            }) scripts
          );
        in
        {
          ".face.icon".source = ../files/face.png;
        }
        // executables;
    };
  };
}
