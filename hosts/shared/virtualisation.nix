{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      autoPrune.enable = true;
      enableNvidia = true;
      extraPackages = with pkgs; [
        dive
        podman-compose
      ];
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
