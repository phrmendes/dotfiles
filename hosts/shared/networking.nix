{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    extraHosts = ''
      127.0.0.1 kubernetes.default.svc.cluster.local
    '';
    firewall = {
      allowedTCPPorts = [
        8324
        32400
        32469
      ];
      allowedUDPPorts = [
        1900
        5353
        32410
        32412
        32413
        32414
      ];
    };
  };
}
