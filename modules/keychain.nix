{
  lib,
  config,
  ...
}:
{
  options.keychain.enable = lib.mkEnableOption "enable keychain";

  config = lib.mkIf config.keychain.enable {
    programs.keychain = {
      enable = true;
      enableFishIntegration = true;
      keys = [ "id_ed25519" ];
    };
  };
}
