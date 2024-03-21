{
  parameters,
  pkgs,
  inputs,
  ...
}: {
  services = {
    blueman.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tailscale.enable = true;
    udev.enable = true;

    gnome.gnome-keyring.enable = true;

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

    xserver = {
      enable = true;
      autorun = true;
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
      videoDrivers = ["nvidia"];
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "Elegant";
      };
    };
  };
}
