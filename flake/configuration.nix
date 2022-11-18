{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
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
        devices = [ "nodev" ];
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
  };

  networking = {
    hostName = "nixos";
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
      layout = "us,br";
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    gnome.core-utilities.enable = false;
    # for laptop
    # libinput = {
    #   enable = true;
    #   tapping = true;
    #   naturalScrolling = true;
    # };
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

  users.users.${user} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.bash;
  };

  environment = {
    systemPackages = with pkgs; [
      zip
      unzip
      unrar
      tree
      git
      gzip
      pop-gtk-theme
      gnomeExtensions.pop-shell
      gnomeExtensions.caffeine
      gnomeExtensions.appindicator
      gnomeExtensions.vitals
      gnomeExtensions.gsconnect
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.sound-output-device-chooser
    ];
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.05";
}
