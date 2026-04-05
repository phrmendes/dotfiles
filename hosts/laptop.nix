{ config, ... }:
let
  inherit (config.modules) nixos homeManager;
  inherit (config) settings;
in
{
  configurations.nixos.laptop.module =
    {
      pkgs,
      config,
      lib,
      ...
    }:
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

      networking.hostName = "laptop";
      programs.nh.flake = "/home/${settings.user}/Projects/dotfiles";

      machine = {
        type = "laptop";
        monitors.primary = {
          name = "eDP-1";
          resolution = "1920x1080";
          position = "0x0";
        };
      };

      disko.mainDiskDevice = "/dev/disk/by-id/nvme-IM2P33F8ABR2-256GB_5M182L19BN2C";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

      boot = {
        kernelModules = [ "kvm-intel" ];
        kernelParams = [
          "i915.enable_rc6=1"
          "i915.modeset=1"
          "mem_sleep_default=deep"
        ];
        extraModprobeConfig = lib.mkDefault ''
          options snd_hda_intel power_save=1
          options snd_ac97_codec power_save=1
          options iwlwifi power_save=Y
          options iwldvm force_cam=N
        '';
      };

      environment.systemPackages = [ pkgs.powertop ];

      powerManagement = {
        enable = true;
        powertop.enable = true;
      };

      services = {
        power-profiles-daemon.enable = false;
        thermald.enable = true;

        auto-cpufreq = {
          enable = true;
          settings = {
            charger = {
              governor = "performance";
              turbo = "auto";
            };
            battery = {
              governor = "powersave";
              turbo = "never";
            };
          };
        };

        libinput = {
          enable = true;
          touchpad = {
            tapping = true;
            horizontalScrolling = true;
            disableWhileTyping = true;
          };
        };

        logind.settings.Login = {
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "ignore";
          HandlePowerKey = "suspend";
          HandlePowerKeyLongPress = "poweroff";
        };

        system76-scheduler = {
          enable = true;
          useStockConfig = true;
        };
      };

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
