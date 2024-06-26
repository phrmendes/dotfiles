{parameters, ...}: {
  nix = {
    gc.automatic = true;
    settings = {
      auto-optimise-store = false;
      accept-flake-config = true;
      trusted-users = ["root" parameters.user];
      experimental-features = ["flakes" "nix-command"];
    };
  };
}
