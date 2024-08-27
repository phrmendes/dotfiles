{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [podman-compose];
    };
  };
}
