{
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      autoPrune.enable = true;
    };
  };
}
