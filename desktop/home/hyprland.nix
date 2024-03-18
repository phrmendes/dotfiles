{pkgs, ...}: {
  wayland.windowManager.hyprland = let
    wallpaper = ../../dotfiles/background.jpg;
    colors = import ../../shared/catppuccin.nix;
    range = [1 2 3 4 5 6 7 8 9 10];
    switchToDesktop = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") range;
    moveToDesktop = map (x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}") range;
    startupScript = pkgs.writeShellScriptBin "start" ''
      swaybg -i ${wallpaper}
    '';
  in {
    enable = true;
    enableNvidiaPatches = true;
    settings = with colors.catppuccin.pallete.rgba; {
      exec-once = "${startupScript}/bin/start";
      input = {
        kb_layout = "us,br";
        kb_model = "pc104";
        kb_options = "grp:alt_space_toggle";
        kb_rules = "evdev";
        follow_mouse = 0;
        sensitivity = 0;
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgba(${blue}ff) rgba(${green}ff) 60deg";
        "col.inactive" = "rgba(${base}ff)";
      };
      decoration = {
        active_opacity = 1;
        inactive_opacity = 0.9;
        rounding = 10;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(${base}ff)";
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
      monitor = [
        "HDMI-0, 1920x1080, 1920x0, auto"
        "DP-3, 1366x768, 0x0, auto"
      ];
      windowrule = [
        "float,gcolor3"
        "float,nwg-displays"
        "float,nwg-look"
        "float,rofi"
      ];
      bind =
        [
          # apps
          "SUPER,escape,exec,rofi -show power-menu"
          "SUPER,return,exec,kitty"
          "SUPER,space,exec,rofi -show drun"
          "SUPER,E,exec,thunar"
          "SUPER,C,exec,dunstctl close-all"
          ",print,flameshot gui"
          # general operations
          "SUPER ALT,Q,exec,pkill Hyprland"
          "SUPER,F,togglefloating"
          "SUPER,M,movewindow"
          "SUPER,P,pseudo"
          "SUPER,Q,killactive"
          "SUPER,T,togglesplit"
          "SUPER,Z,fullscreen"
          # swaylock
          "SUPER,L,exec,swaylock"
          "SUPER SHIFT,L,exec,swaylock; sleep 1; systemctl suspend -i"
          # resize
          "SUPER CTRL,left,resizeactive,-10 0"
          "SUPER CTRL,right,resizeactive,10 0"
          "SUPER CTRL,up,resizeactive,0 -10"
          "SUPER CTRL,down,resizeactive,0 10"
          # windows
          "SUPER,H,movefocus,l"
          "SUPER,J,movefocus,d"
          "SUPER,K,movefocus,u"
          "SUPER,L,movefocus,r"
          # monitors
          "SUPER ALT,H,focusmonitor,l"
          "SUPER ALT,L,focusmonitor,r"
          "SUPER SHIFT ALT,H,movecurrentworkspacetomonitor,l"
          "SUPER SHIFT ALT,L,movecurrentworkspacetomonitor,r"
          # workspaces
          "SUPER CTRL,H,movetoworkspace, m-1"
          "SUPER CTRL,L,movetoworkspace, m+1"
          "SUPER SHIFT CTRL,H,workspace, m-1"
          "SUPER SHIFT CTRL,L,workspace, m+1"
          # media keys
          ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioPlay,exec,playerctl play-pause"
          ",XF86AudioNext,exec,playerctl next"
          ",XF86AudioPrev,exec,playerctl previous"
        ]
        ++ switchToDesktop
        ++ moveToDesktop;
    };
  };
}
