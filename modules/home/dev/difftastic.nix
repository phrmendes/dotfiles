{
  flake.modules.homeManager.difftastic = {
    programs.difftastic = {
      enable = true;
      jujutsu.enable = true;
      git = {
        enable = true;
        mode = "both";
      };
    };
  };
}
