{
  nix.settings = {
    auto-optimise-store = true;
    accept-flake-config = true;
    trusted-users = ["root" "@wheel"];
    experimental-features = ["flakes" "nix-command"];
  };
}
