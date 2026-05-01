_: {
  modules.homeManager.dev.ripgrep = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob"
        "!.git"
        "--glob"
        "!.venv"
        "--glob"
        "!.github"
        "--glob"
        "!.stversions"
        "--glob"
        "!.stfolder"
        "--glob"
        "!.sync"
      ];
    };
  };
}
