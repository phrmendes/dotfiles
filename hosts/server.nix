{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.server.module =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports =
        (with nixos.core; [
          age
          boot
          disko
          filesystems
          hardware
          home-manager
          i18n
          impermanence
          networking
          nix-settings
          nixpkgs
          options
          programs
          security
          services
          stylix
          swap
          system-packages
          users
          virtualisation
        ])
        ++ (with nixos.server; [
          filesystems
          persistence
          secrets
          tailscale
        ]);

      networking.hostName = "server";
      programs.nh.flake = "/home/${settings.user}/dotfiles";
      machine.type = "server";

      disko.mainDiskDevice = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot.kernelModules = [
        "ip_tables"
        "ip6_tables"
      ];

      environment.systemPackages = with pkgs; [
        gh
        just
        neovim
        python313
      ];

      systemd = {
        paths = {
          nixos-rebuild-switch = {
            wantedBy = [ "multi-user.target" ];
            pathConfig = {
              PathChanged = "${settings.home}/dotfiles/secrets";
              Unit = "nixos-rebuild-switch.service";
            };
          };
          docker-compose-config = {
            wantedBy = [ "multi-user.target" ];
            pathConfig = {
              PathChanged = "${settings.home}/dotfiles/compose";
              Unit = "docker-compose.service";
            };
          };
          docker-compose-env = {
            wantedBy = [ "multi-user.target" ];
            pathConfig = {
              PathChanged = config.age.secrets."docker-compose.env".path;
              Unit = "docker-compose.service";
            };
          };
        };
        timers.git-pull = {
          description = "Timer for git pull service";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 06:00,18:00";
            Persistent = true;
            RandomizedDelaySec = "5m";
          };
        };
        services = {
          nixos-rebuild-switch = {
            description = "NixOS rebuild switch service";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = settings.user;
              Group = "users";
              StandardOutput = "journal";
              StandardError = "journal";
              ExecStart = "/run/wrappers/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${settings.home}/dotfiles#${config.networking.hostName}";
            };
          };
          docker-compose =
            let
              env = config.age.secrets."docker-compose.env".path;
              compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
            in
            {
              description = "Docker Compose services";
              after = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${settings.home}/dotfiles/compose";
                ExecStart = "${compose} up --detach --remove-orphans --force-recreate --pull always";
                ExecStop = "${compose} down";
                ExecReload = "${compose} down; ${compose} up --detach --remove-orphans --force-recreate --pull always";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
              };
            };
          git-pull = {
            description = "Git pull dotfiles repository";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = settings.user;
              Group = "users";
              WorkingDirectory = "${settings.home}/dotfiles";
              ExecStartPre = "${pkgs.git}/bin/git fetch --quiet";
              ExecStart = "${pkgs.git}/bin/git pull --ff-only --quiet";
              StandardOutput = "journal";
              StandardError = "journal";
            };
          };
        };
      };

      home-manager.users.${settings.user} = {
        imports =
          (with homeManager.user; [
            base
          ])
          ++ (with homeManager.dev; [
            bat
            btop
            fd
            fzf
            git
            jq
            ripgrep
            zoxide
            zsh
          ]);

        xdg.configFile."nvim/init.lua".source = ../files/neovim.lua;
      };
    };
}
