{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/55576cfc-09c8-473e-8e57-92f182579231";
      fsType = "ext4";
    };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/db084812-d6c8-4a45-9f32-31fec142234b";
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F6DE-EAFD";
      fsType = "vfat";
    };
  swapDevices = [
    {
      device = "/swapfile";
      size = 10000;
    }
  ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
