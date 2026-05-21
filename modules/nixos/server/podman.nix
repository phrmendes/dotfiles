{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.podman =
    { pkgs, ... }:
    {
      virtualisation = {
        oci-containers.backend = "podman";
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
            flags = [ "--all" ];
          };
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      systemd = {
        sockets.podman.wantedBy = [ "sockets.target" ];
        services.podman-network-services = {
          description = "Create Podman services network";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.podman ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            if ! podman network exists services; then
              podman network create --subnet ${settings.podman.subnet} services
            fi
          '';
        };
        timers.podman-auto-update = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "1h";
          };
        };
      };
    };
}
