{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6a7d1b99-e62f-4d51-8e19-7c5fab22dfc5";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/237f27ba-3115-4704-aac7-a1544f725fd5";
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A6D2-B8AE";
    fsType = "vfat";
  };
  swapDevices = [ {device = "/swapfile"; size = 10000;} ];  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
