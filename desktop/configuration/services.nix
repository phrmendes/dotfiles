{
  parameters,
  pkgs,
  inputs,
  ...
}: {
  services = {
    flatpak.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    udev.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;

    journald.extraConfig = "SystemMaxUse=1G";

    duplicati = {
      inherit (parameters) user;
      enable = true;
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
      xkb.layout = "us,br";
      videoDrivers = ["nvidia"];
      displayManager = {
        defaultSession = "hyprland";
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };
}
