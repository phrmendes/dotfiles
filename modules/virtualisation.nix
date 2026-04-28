_: {
  modules.nixos.core.virtualisation = {
    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        daemon.settings = {
          storage-driver = "btrfs";
          dns = [
            "8.8.8.8"
            "1.1.1.1"
          ];
        };
      };
    };
  };
}
