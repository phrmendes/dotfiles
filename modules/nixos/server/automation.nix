{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.automation =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dotfiles = "${settings.home}/dotfiles";
      deployNotify = pkgs.writeShellApplication {
        name = "deploy-notify";
        runtimeInputs = [
          pkgs.local.telegram-notify
          pkgs.systemd
        ];
        text = ''
          ERROR_LOG=$(journalctl -u deploy --since "3 min ago" -p err --no-pager -n 5 -o cat 2>/dev/null || true)
          if [ -z "$ERROR_LOG" ]; then
            ERROR_LOG="No error details available. Check journalctl -u deploy.service for details."
          fi
          telegram-notify error "Deploy failed" "<pre>$ERROR_LOG</pre>"
        '';
      };
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

        services.deploy = {
          description = "Pull dotfiles and rebuild NixOS";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";
            StandardOutput = "journal";
            StandardError = "journal";
            User = settings.user;
            Group = "users";
            WorkingDirectory = dotfiles;
            TimeoutStartSec = 0;
            ExecStart = lib.getExe (pkgs.local.deploy dotfiles);
          };
          onFailure = [ "deploy-notify.service" ];
        };

        services.deploy-notify = {
          serviceConfig = {
            Type = "oneshot";
            ExecStart = lib.getExe deployNotify;
            EnvironmentFile = config.age.secrets."telegram.env".path;
          };
        };
      };
    };
}
