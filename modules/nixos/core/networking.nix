{ config, lib, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.networking =
    { pkgs, config, ... }:
    {
      services.tailscale.useRoutingFeatures = lib.mkDefault "client";

      networking = {
        useDHCP = lib.mkDefault true;
        firewall = {
          enable = true;
          allowedTCPPorts = [ 22 ];
        };
        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
          unmanaged = [ "interface-name:tailscale0" ];
        };
        extraHosts = ''
          127.0.0.1 kubernetes.default.svc.cluster.local
        '';
      };

      systemd.services.prefer-lan-routes = {
        description = "Prefer direct LAN routes over Tailscale";
        after = [
          "network-online.target"
          "tailscaled.service"
        ];
        wants = [
          "network-online.target"
          "tailscaled.service"
        ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.iproute2 ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = "ip rule add priority 5200 to ${settings.lan.subnet} table main";
        postStop = "ip rule del priority 5200 to ${settings.lan.subnet} table main";
      };
    };
}
