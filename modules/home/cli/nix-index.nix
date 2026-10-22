{
  flake.modules.homeManager.nix-index = {
    programs = {
      nix-index-database.comma.enable = true;
    };
  };
}
