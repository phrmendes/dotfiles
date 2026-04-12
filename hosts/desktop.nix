{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.desktop.module =
    { config, lib, ... }:
    {
      imports =
        (with nixos.core; [
          age
          boot
          disko
          filesystems
          hardware
          home-manager
          i18n
          impermanence
          networking
          nix-settings
          nixpkgs
          options
          programs
          security
          services
          stylix
          swap
          system-packages
          users
          virtualisation
        ])
        ++ [ nixos.workstation.common ];

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
