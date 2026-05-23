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
          hyprland
          libvirtd
          noctalia
          persistence
          pipewire
          podman
          syncthing
          xdg-portal
        ]);

      networking.hostName = "desktop";
      machine.dotfilesDir = "${settings.home}/Projects/dotfiles";
      programs.nh.flake = "${settings.home}/Projects/dotfiles";

      machine = {
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
      ];

      boot = {
        initrd.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        kernelParams =
          let
            m = config.machine.monitors.primary;
          in
          [
            "boot.shell_on_fail"
            "video=${m.name}:${m.resolution}@${toString m.refreshRate}"
            "video=DP-3:2560x1080@60"
            "nvidia_drm.modeset=1"
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
          package = config.boot.kernelPackages.nvidiaPackages.production;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

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
          docker
          eza
          fd
          fzf
          gh
          git
          jq
          k8s
          kitty
          lazydocker
          lazygit
          neovim
          nix-index
          opencode
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
          gtk
          hyprland
          imv
          lua
          keepassxc
          mpv
          neovide
          noctalia
          packages
          udiskie
          xdg
          zathura
        ]);
    };
}
