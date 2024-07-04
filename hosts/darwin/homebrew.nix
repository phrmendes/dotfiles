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
      "podman"
      "podman-compose"
      "qemu"
    ];
    casks = [
      "amethyst"
      "firefox"
      "flameshot"
      "keepingyouawake"
      "maccy"
      "microsoft-teams"
      "mongodb-compass"
      "obsidian"
      "postman"
      "qview"
      "slack"
      "tailscale"
      "vagrant"
      "whichspace"
      "zoom"
    ];
  };
}
