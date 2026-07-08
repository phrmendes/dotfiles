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
        builtins.attrValues nixos.core
        ++ (with nixos.workstation; [
          age
          hyprland
          libvirtd
          noctalia
          impermanence
          pipewire
          podman
          syncthing
          xdg-portal
          gaming
        ]);

      networking.hostName = "desktop";
      programs.nh.flake = "${settings.home}/Projects/dotfiles";

      machine = {
        dotfilesDir = "${settings.home}/Projects/dotfiles";
        type = "desktop";
        monitors = {
          primary = {
            name = "DP-3";
            resolution = "2560x1080";
            position = "0x0";
          };
          secondary = {
            name = "HDMI-A-1";
            resolution = "1920x1080";
            position = "2560x0";
          };
        };
      };

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

      home-manager.users.${settings.user}.imports =
        (with homeManager.user; [
          base
          symlinks
        ])
        ++ (with homeManager.dev; [
          atuin
          bat
          btop
          direnv
          eza
          fd
          fzf
          gh
          git
          jq
          k8s
          kitty
          neovim
          nix-index
          pi
          packages
          ripgrep
          starship
          tealdeer
          tmux
          yazi
          zoxide
          zsh
        ])
        ++ (with homeManager.workstation; [
          chromium
          cliphist
          flameshot
          gaming
          gnupg
          gtk
          hyprland
          imv
          lua
          keepassxc
          mpv
          neovide
          noctalia
          packages
          stremio
          udiskie
          xdg
          zathura
        ]);
    };
}
