{ config, ... }:
{
  modules.homeManager.dev.jujutsu =
    { pkgs, lib, ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            inherit (config.settings) name email;
          };
          ui = {
            pager = "${lib.getExe pkgs.bat} -p";
            "diff-editor" = "nvim-codediff";
            "merge-editor" = "nvim-codediff";
          };
          signing = {
            "sign-all" = true;
            backend = "gpg";
            key = config.settings.email;
          };
          "merge-tools"."nvim-codediff" = {
            program = "nvim";
            "diff-args" = [
              "$left"
              "$right"
              "+CodeDiff file $left $right"
            ];
            "merge-args" = [
              "$output"
              "+CodeDiff merge $output"
            ];
            "merge-tool-edits-conflict-markers" = true;
          };
        };
      };
    };
}
