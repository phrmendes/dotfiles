{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];
    };
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
