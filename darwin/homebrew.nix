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
      "qview"
    ];
    casks = [
      "amethyst"
      "firefox"
      "keepingyouawake"
      "maccy"
      "postman"
      "slack"
      "tailscale"
      "wezterm"
    ];
  };
}
