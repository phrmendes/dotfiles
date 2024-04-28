{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lazygit.enable = lib.mkEnableOption "enable lazygit";

  config = lib.mkIf config.lazygit.enable {
    programs.lazygit = let
      colors = import ./catppuccin.nix;
    in {
      enable = true;
      settings = {
        disableStartupPopups = true;
        gui = {
          nerdFontsVersion = "3";
          theme = with colors.catppuccin.hex; {
            activeBorderColor = [blue "bold"];
            inactiveBorderColor = [subtext0];
            optionsTextColor = [blue];
            selectedLineBgColor = [surface0];
            cherryPickedCommitBgColor = [surface1];
            cherryPickedCommitFgColor = [blue];
            unstagedChangesColor = [red];
            defaultFgColor = [text];
            searchingActiveBorderColor = [yellow];
          };
        };
        git.paging = {
          colorArg = "always";
          pager = "${lib.getExe pkgs.delta} --dark --paging=never";
        };
      };
    };
  };
}
