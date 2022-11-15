{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1024x768";
        configurationLimit = 5; # number of listed generations in grub
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/sda1";
        preLVM = true;
        allowDiscards = true;
      }
    ];
  };

  networking = {
    hostName = "nixos"
      networkmanager.enable = true;  # for pc
    # wireless.enable = true; # for laptop
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      layout = "us,br"
        desktopManager.xfce.enable = true;
      displayManager.lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "phrmendes";
          extraConfig = ''
                [greeter]
                show-password-label = true
                password-label-text = Password:
                password-alignment = left
                [greeter-theme]
                font = "Fira Code"
                background-image = ""
            '';
        };
      };
      windowManager.bspwm.enable = true;
      # libinput = {
      #   enable = true;
      #   tapping = true;
      #   naturalScrolling = true;
      # } # for laptops
    }
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  users.users.phrmendes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.fish;
  };

  system.stateVersion = "22.05";
}
