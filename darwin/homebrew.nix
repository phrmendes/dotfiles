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
      "openssl"
    ];
    casks = [
      "amethyst"
      "firefox"
      "keepingyouawake"
      "maccy"
      "postman"
      "qview"
      "slack"
      "tailscale"
      "whichspace"
    ];
  };
}
