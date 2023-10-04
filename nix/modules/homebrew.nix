{
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = ["homebrew/cask-fonts"];
    brews = [
      "ansible"
      "gnu-sed"
      "libiconv"
      "xz"
    ];
    casks = [
      "amethyst"
      "keepingyouawake"
      "maccy"
      "slack"
      "tailscale"
      "wezterm"
    ];
  };
}
