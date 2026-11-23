{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.nh =
    { config, lib, ... }:
    {
      programs.nh = {
        enable = true;
        flake = lib.mkDefault "${config.home.homeDirectory}/.config/dotfiles";
        clean = {
          enable = true;
          dates = "daily";
          extraArgs = [
            "--keep-since"
            "3d"
            "--keep"
            (toString settings.generations)
          ];
        };
      };
    };
}
