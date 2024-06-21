{
  parameters,
  pkgs,
  ...
}: {
  services = {
    blueman.enable = true;
    envfs.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    ntpd-rs.enable = true;
    tailscale.enable = true;
    udev.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    journald.extraConfig = "SystemMaxUse=1G";

    duplicati = {
      inherit (parameters) user;
      enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
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

    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
        theme = "where_is_my_sddm_theme";
      };
    };

    xserver = {
      enable = true;
      autorun = true;
      videoDrivers = ["nvidia"];
      excludePackages = with pkgs; [xterm];
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
