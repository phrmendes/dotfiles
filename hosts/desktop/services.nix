{
  parameters,
  pkgs,
  ...
}: {
  services = {
    envfs.enable = true;
    gvfs.enable = true;
    ntpd-rs.enable = true;
    tailscale.enable = true;

    udev = {
      enable = true;
      packages = with pkgs.gnome; [gnome-settings-daemon];
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };

    journald.extraConfig = "SystemMaxUse=1G";

    duplicati = {
      inherit (parameters) user;
      enable = true;
    };

    gnome = {
      core-utilities.enable = false;
      gnome-keyring.enable = true;
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
      videoDrivers = ["nvidia"];
      excludePackages = with pkgs; [xterm];
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
