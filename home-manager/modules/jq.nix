{ lib, config, ... }:
{
  options.jq.enable = lib.mkEnableOption "enable jq";

  config = lib.mkIf config.jq.enable {
    programs.jq.enable = true;
  };
}
