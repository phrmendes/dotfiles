{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server = {
    automation =
      { pkgs, config, ... }:
      let
        dotfiles = "${config.users.users.${settings.user}.home}/dotfiles";
        composeJust = "${pkgs.just}/bin/just --justfile ${dotfiles}/compose/justfile";
        env = config.age.secrets."docker-compose.env".path;
        compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
        basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin";
        uid = toString config.users.users.${settings.user}.uid;
        dockerSocket = "/run/user/${uid}/docker.sock";
        dockerHost = "unix://${dockerSocket}";
        journalOutput = {
          StandardOutput = "journal";
          StandardError = "journal";
        };
        oneshotService = {
          Type = "oneshot";
        }
        // journalOutput;
      in
      {
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
            docker-compose = {
              description = "Docker Compose services";
              after = [
                "user@${uid}.service"
                "network-online.target"
              ];
              wants = [
                "user@${uid}.service"
                "network-online.target"
              ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = oneshotService // {
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                ExecStartPre = "${pkgs.bash}/bin/bash -c 'until [ -S ${dockerSocket} ]; do sleep 1; done'";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                Environment = [ "DOCKER_HOST=${dockerHost}" ];
              };
            };

            git-pull = {
              description = "Pull dotfiles from remote";
              after = [ "network-online.target" ];
              wants = [ "network-online.target" ];
              serviceConfig = oneshotService // {
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${composeJust} pull";
                TimeoutStartSec = 120;
                Environment = [ "PATH=${basePath}" ];
              };
            };

            nixos-apply = {
              description = "Apply NixOS configuration if changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = oneshotService // {
                WorkingDirectory = dotfiles;
                ExecStart = "${composeJust} apply";
                TimeoutStartSec = 0;
                Environment = [ "PATH=${basePath}:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin" ];
              };
            };

            compose-sync = {
              description = "Sync docker-compose if secrets or compose files changed";
              after = [
                "git-pull.service"
                "nixos-apply.service"
              ];
              requires = [ "git-pull.service" ];
              serviceConfig = oneshotService // {
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${composeJust} sync";
                TimeoutStartSec = 0;
                Environment = [
                  "PATH=${basePath}:${pkgs.docker-compose}/bin"
                  "DOCKER_HOST=${dockerHost}"
                ];
              };
            };
          };
        };
      };

    persistence = {
      environment.persistence."/persist".users.${settings.user}.directories = [
        "dotfiles"
        ".config"
        ".ssh"
        ".local/share"
        ".local/state"
      ];
    };

    tailscale = {
      services.tailscale = {
        useRoutingFeatures = "both";
        extraUpFlags = [ "--advertise-tags=tag:main" ];
        extraSetFlags = [
          "--advertise-exit-node"
          "--accept-routes"
          "--advertise-routes=192.168.0.0/24"
        ];
      };
    };

    filesystems = {
      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/external";
        fsType = "ext4";
        options = [ "defaults" ];
      };

      systemd.tmpfiles.rules = [
        "d /run/sync 0700 ${settings.user} users -"
        "d /mnt/external 2775 ${settings.user} users -"
      ];
    };
  };
}
