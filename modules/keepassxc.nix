{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keepassxc.enable = lib.mkEnableOption "enable keepassxc";

  config = lib.mkIf config.keepassxc.enable {
    home.packages = with pkgs; [ keepassxc ];

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "Offline password manager with many features";
        PartOf = [ "multi-user.target" ];
        Wants = [ "ssh-agent.service" ];
        After = [ "multi-user.target" ];
      };
      Service = {
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized";
        Restart = "always";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };
  };
}
