{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.automation =
    { pkgs, config, ... }:
    let
      dotfiles = "${settings.home}/dotfiles";
      rootJust = "${pkgs.just}/bin/just --justfile ${dotfiles}/justfile";
      basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin:${pkgs.docker-compose}/bin:${pkgs.docker}/bin";
      dockerSocket = "/run/docker.sock";
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

        services =
          let
            dockerDeps = [
              "docker.service"
              "network-online.target"
              "systemd-sysctl.service"
              "mnt-external.mount"
            ];
            commonService = {
              User = settings.user;
              Group = "users";
              WorkingDirectory = dotfiles;
            };
          in
          {
            docker-compose = {
              description = "Docker Compose services";
              after = dockerDeps;
              wants = dockerDeps;
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig =
                oneshotService
                // commonService
                // {
                  RemainAfterExit = true;
                  Group = "docker";
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
                      "${pkgs.bash}/bin/bash -c 'deadline=$((SECONDS+60)); until ${secretChecks}; do [ $SECONDS -lt $deadline ] || { echo \"Timed out waiting for age secrets\" >&2; exit 1; }; sleep 1; done'"
                    ];
                  ExecStart = "${rootJust} compose::up";
                  ExecStop = "${rootJust} compose::down";
                  TimeoutStartSec = 120;
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
              serviceConfig =
                oneshotService
                // commonService
                // {
                  ExecStart = "${rootJust} pull";
                  TimeoutStartSec = 120;
                  Environment = [ "PATH=${basePath}" ];
                };
            };

            dotfiles-sync = {
              description = "Rebuild NixOS or reload compose if relevant files changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig =
                oneshotService
                // commonService
                // {
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
}
