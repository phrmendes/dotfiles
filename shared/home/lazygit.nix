{
  programs.lazygit = {
    enable = true;
    settings = {
      gui.nerdFontsVersion = "3";
      os = {
        edit = "nvim --server $NVIM --remote-tab {{filename}}";
        editAtLine = "nvim --server $NVIM --remote-tab {{filename}}";
        editAtLineAndWait = "nvim --server $NVIM --remote-tab {{filename}}";
      };
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
