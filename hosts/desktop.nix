{ config, ... }:
let
  inherit (config) nixosModules settings homeModules;
in
{
  configurations.nixos.desktop.module =
    { config, lib, ... }:
    {
      imports = with nixosModules; [
        core
        disko
        workstation
        gaming
        sunshine
      ];

      workstation = {
        type = "desktop";
        dotfilesDir = "/home/phrmendes/Projects/dotfiles";
        monitors = {
          primary = {
            name = "DP-3";
            resolution = "2560x1080";
            position = "0x0";
            refreshRate = 60;
            scale = 1.0;
          };
          secondary = {
            name = "HDMI-A-1";
            resolution = "1920x1080";
            position = "2560x0";
            refreshRate = 60;
            scale = 1.0;
          };
        };
      };

      networking.hostName = "desktop";
      programs.nh.flake = "${settings.home}/Projects/dotfiles";

      disko.mainDiskDevice = "/dev/disk/by-id/ata-ADATA_SU630_2M032LSQCCH7";

      boot.kernelModules = [
        "kvm-amd"
        "snd-aloop"
        "hid-playstation"
        "hidp"
      ];

      boot = {
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
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/external";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /mnt/external 0755 ${settings.user} users -"
      ];

      home-manager.users.${settings.user}.imports = with homeModules; [
        atuin
        base
        bat
        btop
        chromium
        cliphist
        devenv
        direnv
        eza
        fd
        flameshot
        fzf
        gaming
        gh
        ghostty
        git
        gnupg
        gtk
        hyprland
        imv
        jq
        k8s
        keepassxc
        lua
        mpv
        neovide
        neovim
        nix-index
        noctalia
        packages
        pi
        ripgrep
        sesh
        starship
        symlinks
        tealdeer
        tmux
        udiskie
        xdg
        yazi
        zathura
        zoxide
        zsh
      ];
    };
}
