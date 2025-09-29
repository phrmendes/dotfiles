{
  config,
  inputs,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ../shared
    ./age.nix
    ./stylix.nix
  ];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
    sensor.iio.enable = true;
  };

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

  environment.systemPackages = with pkgs; [ powertop ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking = {
    hostName = "laptop";
    firewall.allowedTCPPorts = [
      22
      9000
    ];
  };

  programs = {
    dconf.enable = true;
    file-roller.enable = true;
    hyprland.enable = true;
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
    flatpak.enable = true;
    power-profiles-daemon.enable = false;
    syncthing.enable = true;
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

    tailscale = {
      useRoutingFeatures = "client";
      extraUpFlags = [ "--advertise-tags=tags:main" ];
      extraSetFlags = [ "--accept-routes" ];
    };

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
  };

  security.pam.services = {
    hyprlock.gnupg.enable = true;
    greetd = {
      gnupg.enable = true;
      enableGnomeKeyring = true;
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
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
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
    ".config"
    ".docker"
    ".gnupg"
    ".kube"
    ".mongodb"
    ".mozilla"
    ".password-store"
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
    ".local/bin"
  ];

  home-manager.users.${parameters.user} = {
    atuin.enable = true;
    bat.enable = true;
    blueman-applet.enable = true;
    btop.enable = true;
    cliphist.enable = true;
    direnv.enable = true;
    dunst.enable = true;
    eza.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    gh.enable = true;
    git.enable = true;
    gtk-settings.enable = true;
    hypridle.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    hyprpaper.enable = true;
    imv.enable = true;
    jq.enable = true;
    k9s.enable = true;
    keepassxc.enable = true;
    keychain.enable = true;
    kitty.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    neovim.enable = true;
    nm-applet.enable = true;
    packages.enable = true;
    pasystray.enable = true;
    ripgrep.enable = true;
    screenrecorder.enable = true;
    screenshot.enable = true;
    swayosd.enable = true;
    symlinks.enable = true;
    syncthingtray.enable = true;
    targets.enable = true;
    tealdeer.enable = true;
    udiskie.enable = true;
    uv.enable = true;
    waybar.enable = true;
    wofi.enable = true;
    yazi.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
