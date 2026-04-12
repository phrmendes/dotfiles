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
        timers.git-pull = {
          description = "Timer for git pull dotfiles";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 06:00,18:00";
            Persistent = true;
            RandomizedDelaySec = "5m";
          };
        };
        services = {
          docker-compose =
            let
              env = config.age.secrets."docker-compose.env".path;
              compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
            in
            {
              description = "Docker Compose services";
              after = [
                "docker.service"
                "network-online.target"
              ];
              requires = [ "docker.service" ];
              bindsTo = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${settings.home}/dotfiles/compose";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "30s";
                StartLimitIntervalSec = 300;
                StartLimitBurst = 3;
              };
            };

          git-pull = {
            description = "Git pull dotfiles and apply changes";
            after = [
              "network-online.target"
              "docker-compose.service"
            ];
            wants = [ "network-online.target" ];
            requires = [ "docker-compose.service" ];
            serviceConfig = {
              Type = "oneshot";
              User = settings.user;
              Group = "users";
              WorkingDirectory = "${settings.home}/dotfiles";
              ExecStart = "${pkgs.just}/bin/just sync";
              TimeoutStartSec = 0;
              StandardOutput = "journal";
              StandardError = "journal";
              Environment = [
                "PATH=${pkgs.git}/bin:${pkgs.just}/bin:${pkgs.docker-compose}/bin:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin"
              ];
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
