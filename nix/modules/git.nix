{
  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      st = "status";
      rc = "rebase --continue";
      lg = "log";
    };
    delta = {
      enable = true;
      options = {
        core.pager = "delta";
        diff.colorMoved = "default";
        interactive.diffFilter = "delta --color-only";
        merge.conflictStyle = "diff3";
        delta = {
          light = false;
          navigate = true;
          side-by-side = true;
        };
      };
    };
  };
}
