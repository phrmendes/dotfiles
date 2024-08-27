{lib, ...}: {
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
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
