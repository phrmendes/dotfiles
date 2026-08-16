{ inputs, ... }:
{
  homeModules.lua =
    {
      lib,
      pkgs,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.workstation) monitors;
      isLaptop = osConfig.workstation.type == "laptop";
      inherit (osConfig) utils;
      inherit (config.lib.file) mkOutOfStoreSymlink;
      base16 = utils.mkBase16Lua config.lib.stylix.colors;
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

      nix = ''
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

      neovim = ''
        ---@type NixNeovim
        return {
          hyprland = "${pkgs.hyprland}/share/hypr/stubs",
          lua_ls = "${pkgs.lua-language-server}/share/lua-language-server/meta/3rd",
          lualibs = "${inputs.lualibs}/library",
          luatex = "${pkgs.texlivePackages.luatex-type-definitions.tex}/tex/luatex/luatex-type-definitions",
          luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
          sqlite = "${pkgs.sqlite.out}/lib/libsqlite3.so",
        }
      '';

      hyprland = ''
        ---@type NixHyprland
        return {}
      '';

      annotationSrc = name: mkOutOfStoreSymlink "${osConfig.workstation.dotfilesDir}/files/${name}";
    in
    {
      home.file = {
        ".config/hypr/nix.lua".text = nix;
        ".config/hypr/nix/hyprland.lua".text = hyprland;
        ".config/hypr/nix.d.lua".source = annotationSrc "nix.d.lua";
        ".config/hypr/nix/neovim.d.lua".source = annotationSrc "nix.neovim.d.lua";
        ".local/share/nvim/site/lua/nix.lua".text = nix;
        ".local/share/nvim/site/lua/nix/neovim.lua".text = neovim;
        ".local/share/nvim/site/lua/nix/hyprland.lua".text = hyprland;
        ".local/share/nvim/site/lua/nix.d.lua".source = annotationSrc "nix.d.lua";
        ".local/share/nvim/site/lua/nix/neovim.d.lua".source = annotationSrc "nix.neovim.d.lua";
      };
    };
}
