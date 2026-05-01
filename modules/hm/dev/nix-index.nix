_: {
  modules.homeManager.dev.nix-index = {
    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
