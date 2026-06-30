_: {
  modules.homeManager.dev.yazi =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        plugins = with pkgs.yaziPlugins; {
          inherit
            vcs-files
            git
            githead
            ;
        };
        settings = {
          plugin.prepend_fetchers = [
            {
              id = "git";
              url = "*";
              run = "git";
              group = "git";
            }
            {
              id = "git";
              url = "*/";
              run = "git";
              group = "git";
            }
          ];
        };
        initLua = ''
          require("git"):setup()
          require("githead"):setup()
        '';
        keymap = {
          mgr.prepend_keymap = [
            {
              on = [
                "g"
                "c"
              ];
              run = "plugin vcs-files";
              desc = "Show Git file changes";
            }
            {
              on = [
                "g"
                "l"
              ];
              run = ''shell "nvim '+Neogit kind=floating'" --block'';
              desc = "Open Neogit";
            }
          ];
        };
      };
    };
}
