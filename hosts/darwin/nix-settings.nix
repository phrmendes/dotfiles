{
  nix = {
    gc.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
    };
  };
}
