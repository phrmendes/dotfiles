{
  pkgs,
  config,
  ...
}: {
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["btrfs" "ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd" "snd-aloop" "v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
    loader = {
      timeout = 5;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        enableCryptodisk = true;
        useOSProber = true;
        devices = ["nodev"];
      };
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
    };
  };
}
