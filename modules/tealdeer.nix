{
  lib,
  config,
  ...
}:
{
  options.tealdeer.enable = lib.mkEnableOption "enable tealdeer";

  config = lib.mkIf config.tealdeer.enable {
    programs.tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
