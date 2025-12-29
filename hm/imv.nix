{ lib, config, ... }:
{
  options.imv.enable = lib.mkEnableOption "enable imv";

  config = lib.mkIf config.imv.enable {
    programs.imv.enable = true;
  };
}
