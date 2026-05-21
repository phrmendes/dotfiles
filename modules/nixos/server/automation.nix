{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.automation =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      dotfiles = settings.dotfilesDir;
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
        };
      };
    };
}
