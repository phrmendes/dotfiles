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
      insertNameservers = [
        "1.1.1.1"
        "9.9.9.9"
        "100.100.100.100"
      ];
    };
    extraHosts = ''
      127.0.0.1 kubernetes.default.svc.cluster.local
    '';
  };
}
