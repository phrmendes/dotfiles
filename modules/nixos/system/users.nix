{ config, inputs, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.users =
    { lib, pkgs, ... }:
    {

      users = {
        mutableUsers = true;
        defaultUserShell = pkgs.local.nushell;
        groups.external = { };
        users = {
          ${settings.user} = {
            inherit (settings) home;
            openssh.authorizedKeys.keys = map builtins.readFile [
              ../../../files/ssh/desktop.txt
              ../../../files/ssh/deck.txt
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
        sudo.enable = true;
      };

      time = {
        timeZone = "America/Sao_Paulo";
        hardwareClockInLocalTime = false;
      };
      console.keyMap = lib.mkDefault "us";
      system.stateVersion = settings.stateVersion;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = null;
        sharedModules = [ inputs.nix-index-database.homeModules.default ];
      };
    };
}
