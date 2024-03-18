{lib, ...}: {
  networking = {
    hostName = "desktop";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
