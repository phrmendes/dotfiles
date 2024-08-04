{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gvfs
      kdePackages.polkit-kde-agent-1
      psmisc
      wl-clipboard
      xdg-utils
    ];
  };
}
