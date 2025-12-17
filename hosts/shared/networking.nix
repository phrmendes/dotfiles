{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 9000 ];
    };
    networkmanager = {
      enable = true;
      dns = "default";
    };
    extraHosts = ''
      127.0.0.1 kubernetes.default.svc.cluster.local
    '';
  };
}
