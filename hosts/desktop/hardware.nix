{
  config,
  lib,
  ...
}: {
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
