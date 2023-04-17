{ config, pkgs, ... }:
let
  user = "phrmendes";
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
  unstableTarball = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
    ./home.nix
  ];
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 5;
    };
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.unstable.linuxPackages_latest;
  };
  networking = {
    hostName = "nixos-desktop";
    networkmanager.enable = true;
  };
  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "pt_BR.UTF8";
      LC_MEASUREMENT = "pt_BR.UTF8";
      LC_NUMERIC = "pt_BR.UTF8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      cantarell-fonts
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Cantarell" ];
      sansSerif = [ "Cantarell" ];
      monospace = [ "SourceCodePro" ];
    };
  };
  services = {
    clipmenu.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    gnome.core-utilities.enable = false;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      autorun = true;
      layout = "us,br";
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
        };
      };
    };
    journald.extraConfig = "SystemMaxUse=1G";
  };
  security.rtkit.enable = true;
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
    opengl.enable = true;
    nvidia.package = pkgs.unstable.linuxKernel.packages.linux_6_2.nvidia_x11;
  };
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" ];
    initialPassword = "password";
    shell = pkgs.zsh;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-21.4.0" ];
      packageOverrides = pkgs: {
        unstable = import unstableTarball { config = config.nixpkgs.config; };
      };
    };
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      appimage-run
      binutils
      cmake
      curl
      docker-compose
      gcc
      git
      gnumake
      gzip
      home-manager
      unrar
      unzip
      vim
      wget
      zip
      zlib
      gnome.file-roller
      gnome.gnome-calculator
      gnome.gnome-disk-utility
      gnome.gnome-screenshot
      gnome.gnome-tweaks
      gnome.nautilus
    ];
  };
  programs = {
    seahorse.enable = true;
    dconf.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
  };
  system = {
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  };
  virtualisation.docker.enable = true;
}
