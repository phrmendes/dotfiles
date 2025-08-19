{ pkgs, ... }:
{
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      autoPrune.enable = true;
      extraPackages = with pkgs; [
        docker-buildx
        docker-compose
        docker-credential-helpers
      ];
    };
  };
}
