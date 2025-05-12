{
  lib,
  config,
  ...
}:
{
  options.librewolf.enable = lib.mkEnableOption "enable librewolf";

  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.resistFingerprinting" = false;
        "webgl.disabled" = false;
      };
    };
  };
}
