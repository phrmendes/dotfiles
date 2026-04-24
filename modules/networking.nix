_: {
  modules.nixos.core.networking =
    { lib, ... }:
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
    };
}
