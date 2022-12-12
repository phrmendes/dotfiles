{ config, pkgs, ... }:

let
  user = "phrmendes";
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      ./home.nix
    ];
  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        devices = [ "nodev" ];
        gfxmodeEfi = "1024x768";
        configurationLimit = 5;
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
    networkmanager.enable = true;
    wireless.enable = true;
  };
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "SourceCodePro" ];
      };
    };
  };
  services = {
    clipmenu.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;
      autorun = true;
      layout = "us,br";
      videoDrivers = [ "nvidia" ];
      desktopManager.xterm.enable = false;
      desktopManager.plasma5 = {
        enable = true;
        excludePackages = with pkgs.libsForQt5; [
          elisa
          gwenview
          okular
          oxygen
          khelpcenter
          konsole
          print-manager
        ];
      };
      displayManager.sddm.enable = true;
      libinput = {
        enable = true;
        tapping = true;
        naturalScrolling = true;
      };
    };
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
    home = "/home/${user}";
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.bash;
  };
  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = with pkgs; [
      zip
      feh
      curl
      unzip
      unrar
      tree
      git
      gzip
      vim
      appimage-run
      i3
      kde-gruvbox
      gruvbox-dark-gtk
      libsForQt514.kdeconnect-kde
      home-manager
    ];
  };
  programs.dconf.enable = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    trustedUsers = ["root" "@wheel"];
    package = pkgs.nixUnstable;
  };
  system = {
    stateVersion = "unstable";
    system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
    autoUpgrade.enable = true;
    journald.extraConfig = "SystemMaxUse=1G";
  };
}
