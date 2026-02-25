{
  lib,
  config,
  ...
}:
{
  options.nix-index.enable = lib.mkEnableOption "enable nix-index";

  config = lib.mkIf config.nix-index.enable {
    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
