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
    syncthing.enable = true;
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;

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

  environment = {
    cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-player
      cosmic-reader
      cosmic-screenshot
      cosmic-store
      cosmic-term
    ];
    persistence."/persist".users.${parameters.user}.directories = [
      ".cache/clipboard-indicator@tudmotu.com"
      ".cache/helm"
      ".cache/keepassxc"
      ".cache/neovim"
      ".cache/tealdeer"
      ".cache/uv"
      ".cache/zelli"
      ".config"
      ".docker"
      ".gnupg"
      ".kube"
      ".local/bin"
      ".local/share"
      ".local/state"
      ".mozilla"
      ".password-store"
      ".pki"
      ".ssh"
      ".zotero"
      "Documents"
      "Downloads"
      "Pictures"
      "Projects"
      "Videos"
      "Zotero"
    ];
  };

  home-manager.users.${parameters.user} = {
    atuin.enable = true;
    bat.enable = true;
    btop.enable = true;
    copyq.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fd.enable = true;
    fish.enable = true;
    flameshot.enable = true;
    fzf.enable = true;
    gh.enable = true;
    ghostty.enable = true;
    git.enable = true;
    gtk-settings.enable = true;
    imv.enable = true;
    jq.enable = true;
    k9s.enable = true;
    keepassxc.enable = true;
    keychain.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    neovim.enable = true;
    opencode.enable = true;
    packages.enable = true;
    ripgrep.enable = true;
    symlinks.enable = true;
    syncthingtray.enable = true;
    targets.enable = true;
    tealdeer.enable = true;
    yazi.enable = true;
    zathura.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };
}
