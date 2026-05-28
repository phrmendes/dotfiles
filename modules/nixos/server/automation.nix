{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.automation =
    { pkgs, lib, ... }:
    let
      dotfiles = "${settings.home}/dotfiles";
      deployNotify = pkgs.writeShellApplication {
        name = "deploy-notify";
        runtimeInputs = [ pkgs.local.telegram-notify ];
        text = ''telegram-notify error "Deploy Failed: $(hostname)" "Auto-deploy failed on $(hostname). Check journalctl -u deploy.service for details."'';
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
