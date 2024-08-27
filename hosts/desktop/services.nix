{
  parameters,
  pkgs,
  ...
}: {
  services = {
    envfs.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    ntpd-rs.enable = true;
    tailscale.enable = true;

    gnome.core-utilities.enable = false;
    journald.extraConfig = "SystemMaxUse=1G";

    udev = {
      enable = true;
      packages = with pkgs; [gnome.gnome-settings-daemon];
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

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

    xserver = {
      enable = true;
      autorun = true;
      desktopManager.gnome.enable = true;
      videoDrivers = ["nvidia"];

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
