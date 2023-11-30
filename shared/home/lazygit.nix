{
  programs.lazygit = {
    enable = true;
    settings = {
      gui.nerdFontsVersion = "3";
      os = {
        edit = ''nvim --server $NVIM --remote-tab "$(pwd)/{{filename}}"'';
        editAtLine = ''nvim --server $NVIM --remote-tab "$(pwd)/{{filename}}"'';
        editAtLineAndWait = ''nvim --server $NVIM --remote-tab "$(pwd)/{{filename}}"'';
      };
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
