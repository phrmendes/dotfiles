{
  programs.lazygit = {
    enable = true;
    settings = {
      gui.nerdFontsVersion = "3";
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
