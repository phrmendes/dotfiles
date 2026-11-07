{ config, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager nixos;
in
{
  configurations.nixos.desktop.module =
    { config, ... }:
    {
      imports = with nixos; [
        externalDisk
        gaming
        mosh
        sunshine
        workstation
      ];

      externalDisk.device = "/dev/disk/by-label/external";

      workstation = {
        type = "desktop";
        monitors = {
          primary = {
            name = "DP-3";
            resolution = "2560x1080";
            x = 0;
            y = 0;
            refreshRate = 60;
            scale = 1.0;
          };
          secondary = {
            name = "HDMI-A-1";
            resolution = "1920x1080";
            x = 2560;
            y = 0;
            refreshRate = 60;
            scale = 1.0;
          };
        };
      };

      networking.hostName = "desktop";

      disko.mainDiskDevice = "/dev/disk/by-id/ata-ADATA_SU630_2M032LSQCCH7";

      boot = {
        kernelModules = [
          "kvm-amd"
          "snd-aloop"
          "hid-playstation"
          "hidp"
        ];
        initrd.systemd.emergencyAccess = true;
        initrd.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        kernelParams = [
          "nvidia_drm.modeset=1"
          "nvidia_drm.fbdev=1"
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        ];
      };

      hardware = {
        cpu.amd.updateMicrocode = true;
        nvidia-container-toolkit.enable = true;
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          open = true;
          nvidiaSettings = true;
          modesetting.enable = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      externalDisk.directories = [
        {
          path = "pi";
          mode = "0700";
          age = "7d";
        }
      ];

      home-manager.users.${settings.user}.imports = with homeManager; [
        chromium
        gaming
      ];
    };
}
