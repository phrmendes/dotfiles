{
  config,
  inputs,
  lib,
  parameters,
  pkgs,
  ...
}:
let
  fd =
    (pkgs.OVMF.override {
      secureBoot = true;
      tpmSupport = true;
    }).fd;
  versioning = {
    simple = {
      type = "simple";
      params = {
        keep = "10";
        cleanoutDays = "30";
      };
    };
    trashcan = {
      type = "trashcan";
      params.cleanoutDays = "15";
    };
  };
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./shared
  ];

  boot = {
    extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"'';
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    kernelModules = [
      "kvm-amd"
      "snd-aloop"
      "v4l2loopback"
    ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };

  hardware = {
    xpadneo.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  networking.hostName = "desktop";

  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    file-roller.enable = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    virt-manager.enable = true;

    nh.flake = "/home/${parameters.user}/Projects/dotfiles";

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    blueman.enable = true;

    xserver.videoDrivers = [ "nvidia" ];

    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    greetd = {
      enable = true;
      settings = rec {
        terminal.vt = 1;
        initial_session = default_session;
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = parameters.user;
        };
      };
    };

    syncthing.settings.folders = {
      "camera" = {
        path = "${parameters.home}/Pictures/camera";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "phone"
        ];
      };
      "documents" = {
        path = "${parameters.home}/Documents/documents";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "images" = {
        path = "${parameters.home}/Pictures/images";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "notes" = {
        path = "${parameters.home}/Documents/notes";
        versioning = versioning.simple;
        devices = [
          "server"
          "phone"
          "tablet"
        ];
      };
      "ufabc" = {
        path = "${parameters.home}/Documents/ufabc";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "comics" = {
        path = "${parameters.home}/Documents/library/comics";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "IT" = {
        path = "${parameters.home}/Documents/library/IT";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "math" = {
        path = "${parameters.home}/Documents/library/math";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "social_sciences" = {
        path = "${parameters.home}/Documents/library/social_sciences";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "zotero" = {
        path = "${parameters.home}/Documents/library/zotero";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "tablet"
        ];
      };
      "collections" = {
        path = "${parameters.home}/Documents/collections";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "keepassxc" = {
        path = "${parameters.home}/Documents/keepassxc";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "phone"
        ];
      };
    };
  };

  security.pam.services = {
    hyprlock.gnupg.enable = true;
    greetd.gnupg.enable = true;
  };

  stylix = {
    enable = true;
    enableReleaseChecks = false;
    image = ../dotfiles/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
      size = 26;
    };
    fonts = {
      sizes = {
        applications = 12;
        terminal = 12;
      };
      serif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.victor-mono;
        name = "VictorMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      gnome-text-editor.enable = false;
      nixos-icons.enable = false;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ fd ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  environment.persistence."/persist".users.${parameters.user}.directories = [
    "Documents"
    "Downloads"
    "Pictures"
    "Projects"
    "Videos"
    "Zotero"
    ".ansible"
    ".config"
    ".docker"
    ".gnupg"
    ".kube"
    ".mongodb"
    ".mozilla"
    ".pki"
    ".ssh"
    ".zotero"
    ".cache/cliphist"
    ".cache/helm"
    ".cache/keepassxc"
    ".cache/neovim"
    ".cache/tealdeer"
    ".cache/uv"
    ".local/share"
    ".local/state"
  ];
}
