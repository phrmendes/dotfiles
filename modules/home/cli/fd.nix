{
  flake.modules.homeManager.fd = {
    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [ ".git/" ];
    };
  };
}
