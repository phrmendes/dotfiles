{pkgs, ...}: {
  environment = {
    gnome.excludePackages = with pkgs; [gnome-tour];
    systemPackages = with pkgs; [
      appimage-run
      psmisc
      wl-clipboard
      xclip
      xdg-utils
    ];
  };
}
