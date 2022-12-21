{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" ={
    device = "/dev/disk/by-uuid/0b248b0c-d9bf-438c-84f0-1431bcd87d9c";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/975f382e-de1f-4447-ad21-2690a748026e";
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8989-856E";
    fsType = "vfat";
  };
  swapDevices = [ {device = "/swapfile"; size = 10000;} ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
