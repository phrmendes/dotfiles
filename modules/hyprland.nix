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
        hyprlock = getExe pkgs.hyprlock;
        playerctl = getExe pkgs.playerctl;
        wofi = getExe pkgs.wofi;
        bitwarden = getExe pkgs.bitwarden-desktop;
        swayosd = "${pkgs.swayosd}/bin/swayosd-client";
        workspace = rec {
          workspaces = lib.range 1 9;
          move = map (
            x: "SUPER SHIFT, ${builtins.toString x}, movetoworkspace, ${builtins.toString x}"
          ) workspaces;
          switch = map (x: "SUPER, ${builtins.toString x}, workspace, ${builtins.toString x}") workspaces;
          moveSilent = map (
            x: "SUPER SHIFT CTRL, ${builtins.toString x}, movetoworkspacesilent, ${builtins.toString x}"
          ) workspaces;
        };
      in
      {
        enable = true;
        settings = {
          misc.vfr = 0;
          debug.damage_tracking = 0;
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
          render = {
            explicit_sync = 2;
            explicit_sync_kms = 0;
          };
          monitor = with parameters.monitors; [
            "${primary},preferred,auto,1"
          ];
          windowrulev2 = [
            "float,stayfocused,opaque,class:(.blueman-manager-wrapped)"
            "float,stayfocused,opaque,class:(com.gabm.satty)"
            "float,stayfocused,opaque,class:(pavucontrol)"
            "float,stayfocused,opaque,class:(wofi)"
            "float,title:^(Picture-in-Picture)$"
            "opaque,class:^(mpv)$"
          ];
          workspace = with parameters.monitors; [
            "1,monitor:${primary}"
            "2,monitor:${primary}"
            "3,monitor:${primary}"
            "4,monitor:${primary}"
            "5,monitor:${primary}"
            "6,monitor:${primary}"
            "7,monitor:${primary}"
            "8,monitor:${primary}"
            "9,monitor:${primary}"
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
            "SUPER ALT,h,resizeactive,-20 0"
            "SUPER ALT,j,resizeactive,0 20"
            "SUPER ALT,k,resizeactive,0 -20"
            "SUPER ALT,l,resizeactive,20 0"
          ];
          bind =
            [
              "CTRL ALT, L, exec, ${hyprlock}"
              "CTRL ALT, Delete, exec, ${lib.getExe pkgs.wofi-power-menu}"
              ",print,exec,screenshot"
              ",XF86AudioPlay,exec,${playerctl} play-pause"
              ",XF86AudioPause,exec,${playerctl} play-pause"
              ",XF86AudioPrev,exec,${playerctl} previous"
              ",XF86AudioNext,exec,${playerctl} next"
              "SUPER,space,exec,${wofi}"
              "SUPER,tab,changegroupactive,f"
              "SUPER,return,exec,${lib.getExe pkgs.wezterm}"
              "SUPER,B,exec,${lib.getExe pkgs.librewolf}"
              "SUPER,V,exec,${pkgs.cliphist}/bin/cliphist-wofi-img | ${pkgs.wl-clipboard}/bin/wl-copy"
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
              "SUPER,E,exec,${pkgs.wofi-emoji}"
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
        };
        extraConfig = ''
          env = CLUTTER_BACKEND,wayland
          env = GDK_BACKEND,wayland,x11
          env = LIBVA_DRIVER_NAME,nvidia
          env = MOZ_ENABLE_WAYLAND,1
          env = NIXOS_OZONE_WL,1
          env = NVD_BACKEND,direct
          env = QT_QPA_PLATFORM,wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
          env = SDL_VIDEODRIVER,windows,x11
          env = USE_WAYLAND_GRIM,1
          env = XDG_CURRENT_DESKTOP,Hyprland
          env = XDG_SESSION_DESKTOP,Hyprland
          env = XDG_SESSION_TYPE,wayland
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia

          exec-once = ${bitwarden}
        '';
      };
  };
}
