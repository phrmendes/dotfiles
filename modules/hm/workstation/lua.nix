{
  modules.homeManager.workstation.lua =
    {
      lib,
      pkgs,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.machine) isLaptop monitors;
      inherit (osConfig) dotfilesLib;
      inherit (config.lib.file) mkOutOfStoreSymlink;
      base16 = dotfilesLib.mkBase16Lua config.lib.stylix.colors;
      mkMonitor =
        m:
        [
          ''name = "${m.name}"''
          ''mode = "${m.resolution}@${toString m.refreshRate}"''
          ''position = "${m.position}"''
          "scale = ${toString m.scale}"
        ]
        |> lib.concatStringsSep ", "
        |> (s: "{ ${s} }");

      secondaryMonitor =
        if monitors.secondary != null then "secondary = ${mkMonitor monitors.secondary}," else "";

      nixLua = ''
        ---@type Nix
        return {
          colors = {
            ${base16}
          },
          is_laptop = ${if isLaptop then "true" else "false"},
          monitors = {
            primary = ${mkMonitor monitors.primary},
            ${secondaryMonitor}
          },
        }
      '';

      nixNeovimLua = ''
        ---@type NixNeovim
        return {
          luvit_meta     = "${pkgs.vimPlugins.luvit-meta}/library",
          hyprland_stubs = "${pkgs.hyprland}/share/hypr/stubs",
          openresty      = "${pkgs.lua-language-server}/share/lua-language-server/meta/3rd/OpenResty/library",
          typescript     = "${pkgs.typescript}/lib/node_modules/typescript/lib",
        }
      '';

      nixHyprlandLua = ''
        ---@type NixHyprland
        return {}
      '';

      annotationSrc = name: mkOutOfStoreSymlink "${osConfig.machine.dotfilesDir}/files/${name}";
    in
    {
      home.file = {
        ".config/hypr/nix.lua".text = nixLua;
        ".config/hypr/nix/hyprland.lua".text = nixHyprlandLua;
        ".config/hypr/nix.d.lua".source = annotationSrc "nix.d.lua";
        ".config/hypr/nix/neovim.d.lua".source = annotationSrc "nix.neovim.d.lua";
        ".local/share/nvim/site/lua/nix.lua".text = nixLua;
        ".local/share/nvim/site/lua/nix/neovim.lua".text = nixNeovimLua;
        ".local/share/nvim/site/lua/nix/hyprland.lua".text = nixHyprlandLua;
        ".local/share/nvim/site/lua/nix.d.lua".source = annotationSrc "nix.d.lua";
        ".local/share/nvim/site/lua/nix/neovim.d.lua".source = annotationSrc "nix.neovim.d.lua";
      };
    };
}
