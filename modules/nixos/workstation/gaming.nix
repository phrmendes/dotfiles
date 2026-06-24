_: {
  modules.nixos.workstation.gaming =
    { pkgs, ... }:
    {
      hardware.xpadneo.enable = true;

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          gamescopeSession.enable = true;
          extraCompatPackages = with pkgs; [ proton-ge-bin ];
        };

        gamemode = {
          enable = true;
          settings = {
            general = {
              renice = 10;
              ioprio = 0;
            };
            gpu = {
              gpu_io_percent = 100;
            };
          };
        };

        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };

      environment.systemPackages = with pkgs; [
        steam-run
        steamcmd
      ];
    };
}
