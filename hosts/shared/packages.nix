{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gvfs
      psmisc
      wl-clipboard
      xclip
      xdg-utils
    ];
  };
}