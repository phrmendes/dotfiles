{ config, ... }:
let
  inherit (config) nixosModules settings homeModules;
in
{
  configurations.nixos.laptop.module =
    {
      config,
      lib,
      ...
    }:
    {
      imports = with nixosModules; [
        core
        disko
        workstation
      ];

      workstation = {
        type = "laptop";
        dotfilesDir = "/home/phrmendes/Projects/dotfiles";
        monitors = {
          primary = {
            name = "eDP-1";
            resolution = "1920x1080";
            position = "0x0";
            refreshRate = 60;
            scale = 1.0;
          };
        };
      };

      networking.hostName = "laptop";
      programs.nh.flake = "${settings.home}/Projects/dotfiles";

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

      home-manager.users.${settings.user}.imports = with homeModules; [
        atuin
        base
        bat
        btop
        cliphist
        devenv
        direnv
        fd
        flameshot
        fzf
        gh
        kitty
        git
        gnupg
        gtk
        hyprland
        imv
        jq
        k8s
        keepassxc
        lua
        moonlight
        mpv
        neovim
        nix-index
        noctalia
        packages
        pi
        ripgrep
        starship
        symlinks
        tealdeer
        tmux
        udiskie
        xdg
        yazi
        zathura
        zoxide
        nushell
      ];
    };
}
