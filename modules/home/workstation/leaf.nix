{
  flake.modules.homeManager.leaf =
    { pkgs, ... }:
    let
      toml = pkgs.formats.toml { };
    in
    {
      home.packages = [ pkgs.leaf-markdown-viewer ];

      xdg.configFile = {
        "leaf/config.toml".source = toml.generate "leaf-config.toml" { theme = "gruvbox"; };
        "leaf/themes/gruvbox.toml".source = "${pkgs.leaf-markdown-viewer.src}/gruvbox.toml";
      };
    };
}
