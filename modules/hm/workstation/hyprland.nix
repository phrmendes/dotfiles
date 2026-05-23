{
  modules.homeManager.workstation.hyprland =
    {
      config,
      osConfig,
      ...
    }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        settings."exec-once" = [ "hyprctl setcursor Adwaita 24" ];
      };

      xdg.configFile."hypr/hyprland.lua".enable = false;

      home.file.".config/hypr/hyprland.lua".source =
        mkOutOfStoreSymlink "${osConfig.machine.dotfilesDir}/files/hyprland.lua";
    };
}
