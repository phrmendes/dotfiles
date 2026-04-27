{ config, lib, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.networking =
    { pkgs, ... }:
    {
      services = {
        resolved = {
          enable = true;
          settings.Resolve = {
            DNSSEC = "false";
            LLMNR = "false";
          };
        };
        tailscale.useRoutingFeatures = lib.mkDefault "client";
      };

      networking = {
        useDHCP = lib.mkDefault true;
        firewall = {
          enable = true;
          allowedTCPPorts = [ 22 ];
        };
        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
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
          ExecStart = "${pkgs.iproute2}/bin/ip rule add priority 5200 to ${settings.lan.subnet} table main";
          ExecStop = "${pkgs.iproute2}/bin/ip rule del priority 5200 to ${settings.lan.subnet} table main";
        };
      };
    };
}
