{
  flake.modules.homeManager.zellij =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      permissions = {
        vim-zellij-navigator = [
          "ReadApplicationState"
          "ChangeApplicationState"
          "WriteToStdin"
        ];
        zjstatus = [
          "ReadApplicationState"
          "ChangeApplicationState"
          "RunCommands"
        ];
        zj_which_key = [
          "ReadApplicationState"
          "ChangeApplicationState"
          "MessageAndLaunchOtherPlugins"
        ];
      };
    in
    {
      xdg = {
        configFile = {
          "zellij/plugins/vim-zellij-navigator.wasm".source = pkgs.zellijPlugins.vim-zellij-navigator;
          "zellij/plugins/zjstatus.wasm".source = pkgs.zellijPlugins.zjstatus;
          "zellij/plugins/zj_which_key.wasm".source = pkgs.local.zj-which-key;
        };
        cacheFile."zellij/permissions.kdl" = {
          force = true;
          text = lib.hm.generators.toKDL { } (
            lib.mapAttrs' (
              name: grants:
              lib.nameValuePair ''"${config.xdg.configHome}/zellij/plugins/${name}.wasm"'' (
                lib.genAttrs grants (_: { })
              )
            ) permissions
          );
        };
      };

      programs.zellij = {
        enable = true;
        extraConfig = builtins.readFile ../../../files/zellij/config.kdl;
        layouts.main = pkgs.replaceVars ../../../files/zellij/layout.kdl {
          bg = colors.base00;
          fg = colors.base05;
          muted = colors.base03;
          key = colors.base0A;
          accent = colors.base0D;
        };
        settings = {
          default_layout = "main";
          session_name = "default";
          attach_to_session = true;
          default_shell = "nu";
          simplified_ui = true;
          mouse_mode = true;
          scroll_buffer_size = 10000;
          copy_on_select = false;
          pane_frames = false;
          show_release_notes = false;
          show_startup_tips = false;
          web_server = true;
          web_server_ip = "127.0.0.1";
          web_server_port = 8082;
          web_sharing = "on";
        };
        themes = lib.mkIf (config.stylix.targets.zellij.enable or false) {
          stylix.themes.default = {
            ribbon_unselected.emphasis_1 = lib.mkForce colors.base03;
            text_unselected.emphasis_0 = lib.mkForce colors.base04;
            list_selected.background = lib.mkForce colors.base02;
            table_cell_selected.background = lib.mkForce colors.base02;
            text_selected.background = lib.mkForce colors.base02;
            ribbon_selected = {
              background = lib.mkForce colors.base09;
              emphasis_0 = lib.mkForce colors.base00;
              emphasis_1 = lib.mkForce colors.base00;
            };
          };
        };
      };
    };
}
