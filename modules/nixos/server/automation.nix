{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.automation =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      basePath = "${lib.makeBinPath [
        pkgs.bash
        pkgs.just
        pkgs.git
        pkgs.coreutils
        pkgs.docker
      ]}";
      dockerHost = "unix:///run/docker.sock";
      dotfiles = "${settings.home}/dotfiles";
      rootJust = "${lib.getExe pkgs.just} --justfile ${dotfiles}/justfile";
      secretPaths = config.age.secrets |> builtins.attrValues |> map (s: s.path);
      commonService = {
        Type = "oneshot";
        StandardOutput = "journal";
        StandardError = "journal";
        User = settings.user;
        Group = "users";
        WorkingDirectory = dotfiles;
      };
      dockerDeps = [
        "docker.service"
        "network-online.target"
        "systemd-sysctl.service"
        "mnt-external.mount"
      ];
    in
    {
      systemd = {
        timers.deploy = {
          description = "Timer for dotfiles deploy";
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
            after = dockerDeps;
            wants = dockerDeps;
            wantedBy = [ "multi-user.target" ];
            startLimitIntervalSec = 300;
            startLimitBurst = 3;
            serviceConfig = commonService // {
              RemainAfterExit = true;
              Restart = "on-failure";
              RestartSec = 10;
              Group = "docker";
              ExecStartPre = [
                "${lib.getExe pkgs.local.server.wait-for-docker-socket}"
                "${lib.getExe pkgs.local.server.wait-for-age-secrets} ${builtins.concatStringsSep " " secretPaths}"
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

          deploy = {
            description = "Pull dotfiles, rebuild NixOS, and reload compose";
            after = [
              "network-online.target"
              "docker-compose.service"
            ]
            ++ dockerDeps;
            wants = [ "network-online.target" ] ++ dockerDeps;
            wantedBy = [ "multi-user.target" ];
            serviceConfig = commonService // {
              ExecStart = "${rootJust} deploy";
              TimeoutStartSec = 0;
              Environment = [
                "PATH=${basePath}:${lib.makeBinPath [ pkgs.nixos-rebuild ]}:/run/wrappers/bin"
                "DOCKER_HOST=${dockerHost}"
              ];
            };
          };
        };
      };
    };
}
