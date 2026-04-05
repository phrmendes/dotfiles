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
        ++ (with nixos.workstation; [
          blueman
          greetd
          hyprland
          libvirtd
          pam
          pipewire
          persistence
          secrets
          xdg-portal
          syncthing
        ]);

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

      boot = {
        extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
        extraModulePackages = with config.boot.kernelPackages; [
          v4l2loopback.out
          nvidia_x11
        ];
        kernelModules = [
          "kvm-amd"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
          "nvidia_uvm"
          "snd-aloop"
          "v4l2loopback"
        ];
        kernelParams = [
          "nvidia-drm.modeset=1"
          "nvidia-drm.fbdev=1"
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
          powerManagement.enable = false;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      home-manager.users.${settings.user} = {
        imports =
          (with homeManager.user; [
            base
            packages
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
            k9s
            kitty
            lazydocker
            lazygit
            neovim
            nix-index
            opencode
            ripgrep
            starship
            tealdeer
            tmux
            yazi
            zoxide
            zsh
          ])
          ++ (with homeManager.workstation; [
            blueman-applet
            dunst
            flameshot
            gtk
            hyprland
            hypridle
            hyprlock
            hyprpaper
            keepassxc
            nm-applet
            pasystray
            swayosd
            udiskie
            vicinae
            waybar
            xdg
          ])
          ++ (with homeManager.media; [
            imv
            mpv
            zathura
          ]);
      };
    };
}
