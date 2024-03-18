{parameters, ...}: {
  services = {
    flatpak.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    udev.enable = true;

    journald.extraConfig = "SystemMaxUse=1G";

    duplicati = {
      inherit (parameters) user;
      enable = true;
    };

    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
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
  };
}
