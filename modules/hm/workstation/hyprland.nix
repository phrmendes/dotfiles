{
  modules.homeManager.workstation.hyprland =
    {
      config,
      dotfilesDir,
      ...
    }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."hypr/hyprland.lua".enable = false;

      home.file.".config/hypr/hyprland.lua".source =
        mkOutOfStoreSymlink "${dotfilesDir}/files/hyprland.lua";
    };
}
