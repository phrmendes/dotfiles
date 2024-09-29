{
  services = {
    envfs.enable = true;
    flatpak.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    ntpd-rs.enable = true;
    tailscale.enable = true;
    udev.enable = true;
    gnome.gnome-keyring.enable = true;

    journald.extraConfig = "SystemMaxUse=1G";

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        PubKeyAuthentication = true;
      };
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

    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
      autoNumlock = true;
      settings = {
        General = {
          InputMethod = "";
        };
      };
    };

    xserver = {
      enable = true;
      autorun = true;
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
