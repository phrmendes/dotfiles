{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
  coreImports = import ./imports.nix { inherit nixos; };
in
{
  configurations.nixos.desktop.module =
    { config, lib, ... }:
    {
      imports = coreImports ++ [ nixos.workstation.common ];

      networking.hostName = "desktop";
      programs.nh.flake = "/home/${settings.user}/Projects/dotfiles";

      machine = {
        type = "desktop";
        monitors = {
          primary = {
            name = "HDMI-A-1";
            resolution = "2560x1080";
            position = "0x0";
          };
          secondary = {
            name = "DP-2";
            resolution = "1920x1080";
            position = "2560x0";
          };
        };
      };

      disko.mainDiskDevice = "/dev/disk/by-id/ata-ADATA_SU630_2M032LSQCCH7";

      boot.kernelModules = [
        "kvm-amd"
        "snd-aloop"
      ];

      boot.kernelParams = [ "boot.shell_on_fail" ];

      hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
        nvidia-container-toolkit.enable = true;
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          open = true;
          nvidiaSettings = true;
          modesetting.enable = true;
          powerManagement.enable = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      home-manager.users.${settings.user}.imports = [ homeManager.workstation.common ];
    };
}
