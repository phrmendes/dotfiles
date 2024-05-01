{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = let
      inherit (lib) getExe;
      copyq = getExe pkgs.copyq;
      grim = getExe pkgs.grim;
      jq = getExe pkgs.jq;
      kitty = getExe pkgs.kitty;
      nwg-panel = getExe pkgs.nwg-panel;
      playerctl = getExe pkgs.playerctl;
      powermenu = getExe pkgs.nwg-bar;
      satty = getExe pkgs.satty;
      slurp = getExe pkgs.slurp;
      swaybg = getExe pkgs.swaybg;
      walker = getExe pkgs.walker;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      polkit = "${pkgs.kdePackages.polkit-kde-agent-1}/bin/polkit-kde-agent-1";
      swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
      wallpaper = ../dotfiles/background.png;
      colors = import ./catppuccin.nix;
      workspacesKeys = rec {
        workspaces = [1 2 3 4 5 6 7 8 9];
        move = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}") workspaces;
        switch = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") workspaces;
        moveSilent = map (x: "SUPER SHIFT CTRL, ${builtins.toString x}, movetoworkspacesilent, ${builtins.toString x}") workspaces;
      };
      keyboardNotifyScript = pkgs.writeShellScriptBin "keyboard-notify" ''
        KEYBOARD=logitech-k850

        ${hyprctl} switchxkblayout "$KEYBOARD" next &> /dev/null

        LAYOUT=$(${hyprctl} devices -j | ${jq} --arg keyboard "$KEYBOARD" '.keyboards | map(select(.name == $keyboard)) | .[] | .active_keymap')

        ${hyprctl} notify -1 1500 "rgb(f38ba8)" "fontsize:18 ⌨ $LAYOUT" &> /dev/null
      '';
    in {
      enable = true;
      settings = with colors.catppuccin.rgba; {
        exec-once = [
          "${swaybg} --image ${wallpaper} --mode fill"
          "${nwg-panel}"
          "${copyq} --start-server"
          "${polkit}"
        ];
        input = {
          kb_layout = "us,br";
          kb_model = "pc104";
          kb_rules = "evdev";
          numlock_by_default = true;
          follow_mouse = 1;
          sensitivity = 0;
        };
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
          "col.active_border" = "${blue} ${green} 60deg";
          "col.inactive_border" = surface0;
        };
        decoration = {
          active_opacity = 1;
          inactive_opacity = 0.9;
          rounding = 10;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = base;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };
        group = {
          "col.border_active" = "${blue} ${green} 60deg";
          "col.border_inactive" = surface0;
          "col.border_locked_active" = red;
          "col.border_locked_inactive" = surface0;
          groupbar = {
            "col.active" = blue;
            "col.inactive" = surface0;
            "col.locked_active" = red;
            "col.locked_inactive" = surface0;
          };
        };
        monitor = [
          "DP-2,1366x768,0x0,auto"
          "HDMI-A-1,1920x1080,1366x0,auto"
        ];
        windowrulev2 = [
          "float,stayfocused,class:(gcolor3)"
          "float,stayfocused,class:(nwg-displays)"
          "float,stayfocused,class:(pavucontrol)"
          "float,stayfocused,class:(satty)"
          "float,stayfocused,opaque,class:(copyq)"
          "float,stayfocused,opaque,class:(walker)"
          "opaque,class:(chromium)"
          "opaque,class:(firefox)"
          "opaque,class:(vlc)"
        ];
        workspace = [
          "1,monitor:HDMI-A-1"
          "2,monitor:HDMI-A-1"
          "3,monitor:HDMI-A-1"
          "4,monitor:HDMI-A-1"
          "5,monitor:HDMI-A-1"
          "6,monitor:HDMI-A-1"
          "7,monitor:HDMI-A-1"
          "8,monitor:HDMI-A-1"
          "9,monitor:DP-2"
        ];
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        binde = [
          ",XF86AudioMute,exec,${swayosd-client} --output-volume mute-toggle"
          ",XF86AudioRaiseVolume,exec,${swayosd-client} --output-volume raise"
          ",XF86AudioLowerVolume,exec,${swayosd-client} --output-volume lower"
          # resize
          "SUPER ALT,h,resizeactive,-20 0"
          "SUPER ALT,j,resizeactive,0 20"
          "SUPER ALT,k,resizeactive,0 -20"
          "SUPER ALT,l,resizeactive,20 0"
        ];
        bind =
          [
            # apps
            "ALT, space, exec, ${keyboardNotifyScript}/bin/keyboard-notify"
            "SUPER,V,exec,${copyq} menu"
            "SUPER,C,exec,${swaync-client} --close-all"
            "SUPER,N,exec,${swaync-client} --toggle-panel --skip-wait"
            "SUPER,escape,exec,${powermenu}"
            "SUPER,return,exec,${kitty}"
            "SUPER,space,exec,${walker}"
            '',print,exec,${grim} -g "$(${slurp})" - | ${satty} --filename -''
            # general operations
            "SUPER,F,togglefloating"
            "SUPER,P,pseudo"
            "SUPER,Q,killactive"
            "SUPER,R,togglesplit"
            "SUPER,Z,fullscreen"
            # windows and groups
            "SUPER,H,movefocus,l"
            "SUPER,J,movefocus,d"
            "SUPER,K,movefocus,u"
            "SUPER,L,movefocus,r"
            "SUPER SHIFT,H,movewindoworgroup,l"
            "SUPER SHIFT,L,movewindoworgroup,r"
            "SUPER SHIFT,K,movewindoworgroup,u"
            "SUPER SHIFT,J,movewindoworgroup,d"
            "SUPER,T,togglegroup"
            "SUPER,tab,changegroupactive,f"
            "SUPER SHIFT,T,lockactivegroup,toggle"
            # workspaces
            "SUPER CTRL,H,workspace,r-1"
            "SUPER CTRL,L,workspace,r+1"
            "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
            "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
            # music
            ",XF86AudioNext,exec,${playerctl} next"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioPrev,exec,${playerctl} previous"
          ]
          ++ workspacesKeys.switch
          ++ workspacesKeys.move
          ++ workspacesKeys.moveSilent;
      };
    };
  };
}
