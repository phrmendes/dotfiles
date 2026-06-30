{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.server.module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = builtins.attrValues nixos.core ++ builtins.attrValues nixos.server;

      networking.hostName = "server";
      machine.dotfilesDir = "${settings.home}/dotfiles";
      programs.nh.flake = "${settings.home}/dotfiles";
      machine.type = "server";
      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      system.autoUpgrade = {
        enable = true;
        flake = "github:phrmendes/dotfiles#server";
        dates = "06:00,18:00";
        randomizedDelaySec = "5m";
        persistent = true;
      };

      systemd.services = {
        fake-hwclock-restore = {
          description = "Restore system clock from disk";
          wantedBy = [ "sysinit.target" ];
          after = [ "local-fs.target" ];
          before = [ "time-sync.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          path = [ pkgs.coreutils ];
          script = ''
            if [ -f /var/lib/fake-hwclock ]; then
              date -s @$(cat /var/lib/fake-hwclock)
            fi
          '';
        };

        fake-hwclock-save = {
          description = "Save system clock to disk";
          wantedBy = [ "shutdown.target" ];
          before = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          path = [ pkgs.coreutils ];
          script = ''
            date +%s > /var/lib/fake-hwclock
          '';
        };
      };

      home-manager.users.${settings.user}.imports =
        (with homeManager.user; [
          base
        ])
        ++ (with homeManager.dev; [
          bat
          btop
          eza
          fd
          fzf
          git
          jq
          packages
          pi
          ripgrep
          starship
          tealdeer
          tmux
          yazi
          zoxide
          zsh
        ]);
    };
}
