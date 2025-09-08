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
      dns = "systemd-resolved";
      insertNameservers = [
        "100.100.100.100"
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
    extraHosts = ''
      127.0.0.1 kubernetes.default.svc.cluster.local
    '';
  };
}
