_: {
  modules.nixos.core.swap = {
    swapDevices = [
      {
        device = "/persist/swapfile";
        size = 8192;
      }
    ];
  };
}
