{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      autoPrune.enable = true;
      enableNvidia = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
