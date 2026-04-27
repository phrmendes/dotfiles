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
        rootJust = "${pkgs.just}/bin/just --justfile ${dotfiles}/justfile";
        basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin:${pkgs.docker-compose}/bin:${pkgs.docker}/bin";
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
                "systemd-sysctl.service"
                "mnt-external.mount"
              ];
              wants = [
                "user@${uid}.service"
                "network-online.target"
                "systemd-sysctl.service"
                "mnt-external.mount"
              ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = oneshotService // {
                RemainAfterExit = true;
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStartPre =
                  let
                    secretChecks =
                      config.age.secrets
                      |> builtins.attrValues
                      |> map (s: "[ -f ${s.path} ]")
                      |> builtins.concatStringsSep " && ";
                  in
                  [
                    "${pkgs.bash}/bin/bash -c 'until [ -S ${dockerSocket} ]; do sleep 1; done'"
                    "${pkgs.bash}/bin/bash -c 'until ${secretChecks}; do sleep 1; done'"
                  ];
                ExecStart = "${rootJust} compose::up";
                ExecStop = "${rootJust} compose::down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                Environment = [
                  "PATH=${basePath}"
                  "DOCKER_HOST=${dockerHost}"
                  "AGE_SECRETS_PATH=${config.age.secretsDir}"
                ];
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
                ExecStart = "${rootJust} pull";
                TimeoutStartSec = 120;
                Environment = [ "PATH=${basePath}" ];
              };
            };

            dotfiles-sync = {
              description = "Rebuild NixOS or reload compose if relevant files changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = oneshotService // {
                User = settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${rootJust} sync";
                TimeoutStartSec = 0;
                Environment = [
                  "PATH=${basePath}:${pkgs.nixos-rebuild}/bin:${pkgs.docker-compose}/bin:/run/wrappers/bin"
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

    networking =
      { lib, ... }:
      {
        services.resolved.enable = lib.mkForce false;
        networking.nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
      };

    tailscale = {
      services.tailscale = {
        useRoutingFeatures = "both";
        extraSetFlags = [
          "--advertise-exit-node"
          "--accept-routes"
          "--advertise-routes=${settings.lan.subnet}"
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
        "d /mnt/external 2777 ${settings.user} users -"
        "a+ /mnt/external - - - - u:${settings.user}:rwx,u:100999:rwx,o::rwx,d:u:${settings.user}:rwx,d:u:100999:rwx,d:o::rwx"
      ];
    };
  };
}
