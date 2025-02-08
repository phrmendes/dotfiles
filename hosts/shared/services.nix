{
  pkgs,
  lib,
  ...
}:
{
  services = {
    blueman.enable = true;
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

    dbus.packages = with pkgs; [ gcr ];

    openssh = {
      enable = true;
      allowSFTP = true;
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

    greetd = {
      enable = true;
      settings =
        let
          tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
          sessions = "${pkgs.hyprland}/share/wayland-sessions";
        in
        rec {
          terminal.vt = 1;
          initial_session = default_session;
          default_session = {
            command = "${tuigreet} -t -r --asterisks -s ${sessions}";
            user = "greeter";
          };
        };
    };

    xserver = {
      enable = true;
      autorun = true;
      excludePackages = with pkgs; [ xterm ];
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
