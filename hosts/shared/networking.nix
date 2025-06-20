{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    extraHosts = ''
      127.0.0.1 kubernetes.default.svc.cluster.local
    '';
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        53
        22000
        51413
      ];
      allowedUDPPorts = [
        53
        22000
        21027
        51413
      ];
    };
  };
}
