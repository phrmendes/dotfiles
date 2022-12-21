{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bde838e7-eca3-4543-b5f8-4f766fd71869";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/71600493-5d0d-4c71-ae74-eeda36820fb6";
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/02C8-A678";
      fsType = "vfat";
    };
  swapDevices = [ {device = "/swapfile"; size = 10000;} ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
