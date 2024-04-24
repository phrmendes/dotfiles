{
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
    experimental-features = ["flakes" "nix-command"];
  };
}
