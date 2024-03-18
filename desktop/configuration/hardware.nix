{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 5;
    };
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [];

      luks.devices."luks-ab2543df-92ce-477a-ada2-ecfc30c8b152".device = "/dev/disk/by-uuid/ab2543df-92ce-477a-ada2-ecfc30c8b152";
    };
    kernelModules = [
      "kvm-amd"
      "snd-aloop"
      "v4l2loopback"
    ];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6daee98c-1c0d-409d-bab5-bcf67fa89381";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/BA3B-4676";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/7622da1d-0b9d-4882-89d6-f4daf30e004d";}
  ];

  hardware = {
    pulseaudio.enable = false;
    uinput.enable = true;

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
