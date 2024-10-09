{pkgs, ...}: {
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      extraPackages = with pkgs; [docker-compose];
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
