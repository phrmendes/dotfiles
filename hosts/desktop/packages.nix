{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      appimage-run
      psmisc
      wl-clipboard
      xdg-utils
      kdePackages.polkit-kde-agent-1
    ];
  };
}
