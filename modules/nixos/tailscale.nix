{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.tailscale = {
    services.tailscale = {
      useRoutingFeatures = "both";
      extraSetFlags = [
        "--advertise-exit-node"
        "--accept-routes"
        "--advertise-routes=${settings.lan.subnet}"
      ];
    };
  };
}
