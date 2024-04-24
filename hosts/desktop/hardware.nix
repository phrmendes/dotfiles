{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=32G" "mode=755"];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-ESP";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=swap" "noatime"];
    };

    "/tmp" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=tmp" "noatime"];
    };

    "/var/log" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/var/lib" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=lib" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };

  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["btrfs" "ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd" "snd-aloop" "v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
    loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
        useOSProber = true;
      };
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
    };
  };

  swapDevices = [{device = "/swap/swapfile";}];

  hardware = {
    pulseaudio.enable = false;
    uinput.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
      extraPackages = with pkgs; [mesa nvidia-vaapi-driver];
    };

    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
