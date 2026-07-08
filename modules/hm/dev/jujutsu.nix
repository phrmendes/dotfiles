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
            "diff-editor" = "nvim";
            "merge-editor" = "nvim";
            "default-command" = "log";
          };
          signing = {
            "sign-all" = true;
            backend = "gpg";
            key = config.settings.email;
          };
          "merge-tools"."nvim" = {
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

      home.packages = with pkgs; [ lazyjj ];
    };
}
