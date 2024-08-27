{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gvfs
      psmisc
      wl-clipboard
      xdg-utils
    ];
  };
}
