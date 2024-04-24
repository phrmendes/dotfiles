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
      "dbeaver-community"
      "firefox"
      "font-fira-code-nerd-font"
      "keepingyouawake"
      "maccy"
      "microsoft-teams"
      "postman"
      "qview"
      "slack"
      "tailscale"
      "vagrant"
      "whichspace"
    ];
  };
}
