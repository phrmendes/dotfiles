_: {
  modules.homeManager.dev.lazygit =
    { pkgs, lib, ... }:
    {
      programs.lazygit = {
        enable = true;
        settings = {
          promptToReturnFromSubprocess = false;
          disableStartupPopups = true;
          os.editPreset = "nvim-remote";
          gui.nerdFontsVersion = "3";
          git.pagers = [
            {
              colorArg = "always";
              pager = "${lib.getExe pkgs.delta} --dark --paging=never";
              externalDiffCommand = "${lib.getExe pkgs.difftastic} --color=always";
            }
          ];
        };
      };
    };
}
