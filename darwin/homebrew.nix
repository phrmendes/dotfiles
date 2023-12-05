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
      "firefox"
      "flameshot"
      "keepingyouawake"
      "maccy"
      "postman"
      "slack"
      "tailscale"
      "wezterm"
    ];
  };
}
