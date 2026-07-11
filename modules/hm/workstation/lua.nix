{ inputs, ... }:
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
          lua_ls = "${pkgs.lua-language-server}/share/lua-language-server/meta/3rd",
          luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
          hyprland = "${pkgs.hyprland}/share/hypr/stubs",
          typescript = "${pkgs.typescript}/lib/node_modules/typescript/lib",
          luatex = "${pkgs.texlivePackages.luatex-type-definitions.tex}/tex/luatex/luatex-type-definitions",
          lualibs = "${inputs.lualibs}/library",
        }
      '';

      hyprland = ''
        ---@type NixHyprland
        return {}
      '';

      annotationSrc = name: mkOutOfStoreSymlink "${osConfig.machine.dotfilesDir}/files/${name}";
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
