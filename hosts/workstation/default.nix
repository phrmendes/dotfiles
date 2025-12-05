{
  parameters,
  pkgs,
  ...
}:
{
  imports = [ ../shared ];

  age.secrets = {
    "claude-service-account.json" = {
      file = ../../secrets/claude-service-account.json.age;
      owner = parameters.user;
      group = "users";
      mode = "0440";
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    9000
  ];

  programs = {
    dconf.enable = true;
    virt-manager.enable = true;

    nh.flake = "/home/${parameters.user}/Projects/dotfiles";
  };

  services = {
    flatpak.enable = true;
    syncthing.enable = true;

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
    };

    tailscale = {
      useRoutingFeatures = "client";
      extraUpFlags = [ "--advertise-tags=tag:main" ];
      extraSetFlags = [ "--accept-routes" ];
    };

    pipewire = {
      enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  security.pam.services = {
    login = {
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
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  stylix.enable = true;

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
    ".mozilla"
    ".password-store"
    ".pki"
    ".ssh"
    ".zotero"
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
    btop.enable = true;
    dconf-settings.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fd.enable = true;
    fish.enable = true;
    fzf.enable = true;
    gh.enable = true;
    git.enable = true;
    gtk-settings.enable = true;
    imv.enable = true;
    jq.enable = true;
    k9s.enable = true;
    keepassxc.enable = true;
    keychain.enable = true;
    kitty.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    neovim.enable = true;
    packages.enable = true;
    ripgrep.enable = true;
    symlinks.enable = true;
    syncthingtray.enable = true;
    targets.enable = true;
    tealdeer.enable = true;
    yazi.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
