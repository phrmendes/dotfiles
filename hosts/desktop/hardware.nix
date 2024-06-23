{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    pulseaudio.enable = false;
    uinput.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
