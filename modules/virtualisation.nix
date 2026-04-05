_: {
  modules.nixos.core.virtualisation =
    { pkgs, ... }:
    {
      virtualisation = {
        containers.enable = true;
        docker = {
          enable = true;
          storageDriver = "btrfs";
          autoPrune.enable = true;
          daemon.settings.dns = [
            "8.8.8.8"
            "1.1.1.1"
          ];
          extraPackages = with pkgs; [
            docker-buildx
            docker-compose
          ];
        };
      };
    };
}
