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
        9090
        9000
      ];
    };
  };
}
