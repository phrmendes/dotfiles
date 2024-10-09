{
  config,
  lib,
  ...
}: {
  options.k9s.enable = lib.mkEnableOption "enable k9s";

  config = lib.mkIf config.k9s.enable {
    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          refreshRate = 1;
        };
      };
    };
  };
}
