{
  config,
  lib,
  pkgs,
  ...
}: {
  options.firefox.enable = lib.mkEnableOption "enable firefox";

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs.kdePackages; [plasma-browser-integration];
    };
  };
}
