_:
let
  subnet = "172.18.0.0/16";
in
{
  flake.modules.nixos.podmanServer =
    { config, pkgs, ... }:
    {
      age.secrets."dockerhub.json" = config.utils.mkSecretReadable {
        file = ../../../secrets/dockerhub.age.json;
        path = "/root/.docker/config.json";
      };

      virtualisation = {
        oci-containers.backend = "podman";
        podman.autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--all" ];
        };
      };

      systemd = {
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
              podman network create --subnet ${subnet} services
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
