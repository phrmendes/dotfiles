{
  lib,
  config,
  ...
}:
{
  options.fd.enable = lib.mkEnableOption "enable fd";

  config = lib.mkIf config.fd.enable {
    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git/"
      ];
    };
  };
}
