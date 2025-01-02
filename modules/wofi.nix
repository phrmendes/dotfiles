{
  config,
  lib,
  pkgs,
  ...
}: {
  options.wofi.enable = lib.mkEnableOption "enable wofi";

  config = lib.mkIf config.wofi.enable {
    programs.wofi = let
      fonts = config.stylix.fonts;
      colors = config.lib.stylix.colors.withHashtag;
    in {
      enable = true;
      settings = {
        allow_images = true;
        height = "50%";
        hide_scroll = true;
        image_size = "28";
        key_backward = "Ctrl-p";
        key_expand = "Tab";
        key_forward = "Ctrl-n";
        key_pgdown = "Ctrl-d";
        key_pgup = "Ctrl-u";
        key_submit = "Return";
        location = "center";
        mode = "drun";
        no_actions = true;
        term = lib.getExe pkgs.kitty;
        width = "25%";
      };
      style = with colors;
        lib.mkForce ''
          window {
            margin: 0px;
            border: 1px solid ${base02};
            background-color: ${base01};
            font-family: "${fonts.monospace.name}";
            font-size: ${toString fonts.sizes.popups}pt;
          }

          #input {
            margin: 5px;
            border: none;
            color: ${base07};
            background-color: ${base00};
          }

          #inner-box {
            margin: 5px;
            border: none;
            background-color: ${base01};
          }

          #outer-box {
            margin: 5px;
            border: none;
            background-color: ${base01};
          }

          #scroll {
            margin: 0px;
            border: none;
          }

          #text {
            margin: 5px;
            border: none;
            color: ${base07};
          }

          #entry:selected {
            background-color: ${base00};
          }
        '';
    };
  };
}
