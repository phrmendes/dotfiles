{
  flake.modules.homeManager.nushell =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.sessionPath = [ "$HOME/.local/bin" ];

      programs.nushell = {
        enable = true;
        package = pkgs.local.nushell;
        settings = {
          show_banner = false;
          edit_mode = "vi";
          history = {
            file_format = "plaintext";
            path = "/dev/null";
          };
        };
        environmentVariables = {
          PROMPT_INDICATOR_VI_INSERT = "";
          PROMPT_INDICATOR_VI_NORMAL = "";
          _ZO_MAXAGE = "100000";
        };
        shellAliases.bash = lib.getExe pkgs.bashInteractive;
        extraConfig = ''
          $env.config.menus = ($env.config.menus | each {|menu|
            if $menu.name in [completion_menu ide_completion_menu] {
              $menu | upsert marker ""
            } else {
              $menu
            }
          })
        '';
      };
    };
}
