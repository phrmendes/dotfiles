{
  inputs,
  lib,
  parameters,
  pkgs,
  ...
}: {
  services = {
    flatpak.enable = true;
    gvfs.enable = true;
    tailscale.enable = true;

    udev = {
      enable = true;
      packages = with pkgs.gnome; [gnome-settings-daemon];
    };

    gnome = {
      core-utilities.enable = false;
      gnome-keyring.enable = true;
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

    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      enable = true;
      autorun = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us,br";
        options = "grp:alt_space_toggle";
      };
    };
  };
}
