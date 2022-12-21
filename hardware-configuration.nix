{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" ={
    device = "/dev/disk/by-uuid/ece0459b-8058-4143-8c91-b2fbcef4cd09";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/f67000e8-9a58-47d5-a5b6-7816b8afc853";
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/148A-7773";
    fsType = "vfat";
  };
  swapDevices = [ {device = "/swapfile"; size = 10000;} ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
