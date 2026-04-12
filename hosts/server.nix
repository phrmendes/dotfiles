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

      systemd =
        let
          dotfiles = "${settings.home}/dotfiles";
          just = "${pkgs.just}/bin/just";
          env = config.age.secrets."docker-compose.env".path;
          compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
          basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin";
        in
        {
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
            docker-compose = {
              description = "Docker Compose services";
              after = [
                "docker.service"
                "network-online.target"
              ];
              wants = [ "network-online.target" ];
              requires = [ "docker.service" ];
              bindsTo = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "30s";
              };
            };

            git-pull = {
              description = "Pull dotfiles from remote";
              after = [ "network-online.target" ];
              wants = [
                "network-online.target"
                "nixos-apply.service"
                "compose-reload.service"
              ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} pull";
                TimeoutStartSec = 120;
                StandardOutput = "journal";
                StandardError = "journal";
                RuntimeDirectory = "sync";
                RuntimeDirectoryMode = "0755";
                RuntimeDirectoryPreserve = "yes";
                Environment = [ "PATH=${basePath}" ];
              };
            };

            nixos-apply = {
              description = "Apply NixOS configuration if changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} nixos-apply";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin" ];
              };
            };

            compose-reload = {
              description = "Reload docker-compose if changed";
              after = [
                "git-pull.service"
                "nixos-apply.service"
              ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} compose-reload";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.docker-compose}/bin" ];
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
