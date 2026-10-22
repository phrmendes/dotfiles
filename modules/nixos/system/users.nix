{ config, inputs, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.users =
    { pkgs, ... }:
    {

      users = {
        mutableUsers = true;
        groups.external = { };
        users = {
          ${settings.user} = {
            inherit (settings) home;
            shell = pkgs.local.nushell;
            password = "changeme";
            openssh.authorizedKeys.keys = map builtins.readFile [
              ../../../files/ssh/main.txt
              ../../../files/ssh/phone.txt
              ../../../files/ssh/laptop.txt
              ../../../files/ssh/server.txt
            ];
            isNormalUser = true;
            uid = 1000;
            linger = true;
            extraGroups = [
              "external"
              "keys"
              "networkmanager"
              "wheel"
            ];
          };
        };
      };

      security = {
        rtkit.enable = true;
        polkit.enable = true;
        sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };
      };

      time = {
        timeZone = "America/Sao_Paulo";
        hardwareClockInLocalTime = false;
      };
      console.keyMap = "us";
      system.stateVersion = settings.stateVersion;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        sharedModules = [ inputs.nix-index-database.homeModules.default ];
      };
    };
}
