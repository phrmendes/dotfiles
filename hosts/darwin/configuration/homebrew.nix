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
      "gnu-sed"
      "openssl"
      "podman"
      "podman-compose"
      "qemu"
    ];
    casks = [
      "amethyst"
      "bruno"
      "firefox"
      "keepingyouawake"
      "maccy"
      "microsoft-teams"
      "podman-desktop"
      "postman"
      "qview"
      "slack"
      "tailscale"
      "whichspace"
      "font-fira-code-nerd-font"
    ];
  };
}
