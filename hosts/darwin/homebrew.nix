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
    taps = [
      "homebrew/cask-fonts"
    ];
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
      "font-fira-code-nerd-font"
      "keepingyouawake"
      "maccy"
      "microsoft-teams"
      "mongodb-compass"
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
