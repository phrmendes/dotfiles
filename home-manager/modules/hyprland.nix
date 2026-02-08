{
  config,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  options.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland =
      let
        inherit (lib) getExe;
        flameshot = getExe pkgs.flameshot;
        hyprlock = getExe pkgs.hyprlock;
        playerctl = getExe pkgs.playerctl;
        vicinae = getExe pkgs.vicinae;
        swayosd = "${pkgs.swayosd}/bin/swayosd-client";
        ws = lib.range 1 9;
        workspace = {
          move = ws |> map (x: "SUPER SHIFT, ${toString x}, movetoworkspace, ${toString x}");
          switch = ws |> map (x: "SUPER, ${toString x}, workspace, ${toString x}");
          moveSilent = ws |> map (x: "SUPER SHIFT CTRL, ${toString x}, movetoworkspacesilent, ${toString x}");
        };
      in
      {
        enable = true;
        settings = {
          misc.vfr = 0;
          debug.damage_tracking = 2;
          input = {
            kb_layout = "us,br";
            kb_model = "pc104";
            kb_rules = "evdev";
            kb_options = "grp:alt_space_toggle";
            numlock_by_default = true;
            follow_mouse = 1;
            sensitivity = 0;
            touchpad.natural_scroll = true;
          };
          general = {
            gaps_in = 3;
            gaps_out = 6;
            border_size = 2;
            layout = "dwindle";
            resize_on_border = true;
          };
          decoration = {
            active_opacity = 1;
            inactive_opacity = 0.9;
            rounding = 10;
            blur = {
              enabled = false;
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
          monitor = with parameters.monitors; [
            "${primary.name},${primary.resolution},${primary.position},1"
            (lib.mkIf (!parameters.laptop) "${secondary.name},${secondary.resolution},${secondary.position},1")
          ];
          windowrulev2 = [
            "float,stayfocused,opaque,class:(.blueman-manager-wrapped)"
            "float,stayfocused,opaque,class:(org.pulseaudio.pavucontrol)"
            "fakefullscreen,class:(flameshot),title:(flameshot)"
            "float,class:(flameshot),title:(flameshot)"
            "float,title:^(Picture-in-Picture)$"
            "in,class:(flameshot),title:(flameshot)"
            "move 0 0,class:(flameshot),title:(flameshot)"
            "opaque,class:(firefox)"
            "opaque,class:(mpv)"
          ];
          workspace = with parameters.monitors; [
            "1,monitor:${primary.name}"
            "2,monitor:${primary.name}"
            "3,monitor:${primary.name}"
            "4,monitor:${primary.name}"
            "5,monitor:${primary.name}"
            "6,monitor:${primary.name}"
            "7,monitor:${primary.name}"
            "8,monitor:${(lib.attrByPath [ "secondary" ] primary parameters.monitors).name}"
            "9,monitor:${(lib.attrByPath [ "secondary" ] primary parameters.monitors).name}"
          ];
          bindm = [
            "SUPER,mouse:272,movewindow"
            "SUPER,mouse:273,resizewindow"
          ];
          binde = [
            ",XF86AudioRaiseVolume,exec,${swayosd} --output-volume raise --max-volume 150"
            ",XF86AudioLowerVolume,exec,${swayosd} --output-volume lower"
            ",XF86AudioMute,exec,${swayosd} --output-volume mute-toggle"
            ",XF86AudioMicMute,exec,${swayosd} --input-volume mute-toggle"
            (lib.mkIf parameters.laptop ",XF86MonBrightnessUp,exec,${swayosd} --brightness raise")
            (lib.mkIf parameters.laptop ",XF86MonBrightnessDown,exec,${swayosd} --brightness lower")
            "SUPER ALT,h,resizeactive,-20 0"
            "SUPER ALT,j,resizeactive,0 20"
            "SUPER ALT,k,resizeactive,0 -20"
            "SUPER ALT,l,resizeactive,20 0"
          ];
          bind = [
            "CTRL ALT,L,exec,${hyprlock}"
            ",print,exec,${flameshot} gui"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioPause,exec,${playerctl} play-pause"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioNext,exec,${playerctl} next"
            "SUPER,space,exec,${vicinae} toggle"
            "SUPER,tab,changegroupactive,f"
            "SUPER,return,exec,${lib.getExe pkgs.kitty}"
            "SUPER,B,exec,${lib.getExe pkgs.firefox}"
            "SUPER,F,togglefloating"
            "SUPER,G,togglegroup"
            "SUPER,H,movefocus,l"
            "SUPER,J,movefocus,d"
            "SUPER,K,movefocus,u"
            "SUPER,L,movefocus,r"
            "SUPER,P,pseudo"
            "SUPER,Q,killactive"
            "SUPER,R,togglesplit"
            "SUPER,T,lockactivegroup,toggle"
            "SUPER,Z,fullscreen"
            "SUPER CTRL,H,workspace,r-1"
            "SUPER CTRL,L,workspace,r+1"
            "SUPER SHIFT,H,movewindoworgroup,l"
            "SUPER SHIFT,J,movewindoworgroup,d"
            "SUPER SHIFT,K,movewindoworgroup,u"
            "SUPER SHIFT,L,movewindoworgroup,r"
            "SUPER SHIFT CTRL,H,movetoworkspace,r-1"
            "SUPER SHIFT CTRL,L,movetoworkspace,r+1"
          ]
          ++ workspace.switch
          ++ workspace.move
          ++ workspace.moveSilent;
          env = [
            "GDK_BACKEND,wayland"
            "LIBVA_DRIVER_NAME,nvidia"
            "MOZ_ENABLE_WAYLAND,1"
            "NIXOS_OZONE_WL,1"
            "NVD_BACKEND,direct"
            "QT_QPA_PLATFORM,wayland"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "SDL_VIDEODRIVER,wayland"
            "USE_WAYLAND_GRIM,1"
            "WLR_NO_HARDWARE_CURSORS,1"
            "WLR_RENDERER,gles2"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "__GL_SYNC_TO_VBLANK,0"
            "__GL_THREADED_OPTIMIZATIONS,0"
          ];
        };
      };
  };
}
