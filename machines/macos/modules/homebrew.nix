{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brewPrefix = "/opt/homebrew/bin";
    caskArgs = {
      no_quarantine = true;
    };
    brews = [
      "gnu-sed"
      "openssl"
    ];
    casks = [
      "amethyst"
      "bruno"
      "firefox"
      "keepingyouawake"
      "maccy"
      "slack"
      "tailscale"
      "wezterm"
    ];
  };
}
