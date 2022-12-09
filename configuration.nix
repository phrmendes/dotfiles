{ config, pkgs, ... }:

let
  user = "phrmendes";
  unstable = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
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
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      autorun = true;
      layout = "us,br";
      windowManager.xmonad.enable = true;
      displayManager.sddm.enable = true;
    };
    libinput = {
      enable = true;
      tapping = true;
      naturalScrolling = true;
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
    home = "/home/${user}"
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.bash;
  };
  environment = {
    systemPackages = with pkgs; [
      zip
      curl
      unzip
      unrar
      tree
      git
      gzip
      vim
      appimage-run
      home-manager
    ];
  };
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
  system = {
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  }
}
