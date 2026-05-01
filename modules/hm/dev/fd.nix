_: {
  modules.homeManager.dev.fd = {
    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [ ".git/" ];
    };
  };
}
