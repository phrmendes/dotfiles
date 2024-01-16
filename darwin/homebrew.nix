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
      "gnu-sed"
    ];
    casks = [
      "amethyst"
      "firefox"
      "keepingyouawake"
      "maccy"
      "podman-desktop"
      "postman"
      "qview"
      "slack"
      "tailscale"
      "whichspace"
    ];
  };
}
