{
  lib,
  config,
  ...
}: {
  options.gnome-keyring.enable = lib.mkEnableOption "enable gnome-keyring";

  config = lib.mkIf config.gnome-keyring.enable {
    services.gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets" "ssh"];
    };
  };
}
