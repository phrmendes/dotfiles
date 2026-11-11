{
  flake.modules.homeManager.vivid =
    { lib, ... }:
    {
      programs.vivid = {
        enable = true;
        themes.stylix.core.reset_to_normal = lib.mkForce {
          foreground = "base04";
          font-style = "regular";
        };
      };
    };
}
