{
  pkgs,
  lib,
  ...
}: let
  syncthingStartScript = pkgs.writeShellScriptBin "syncthing-start" ''
    ${pkgs.coreutils}/bin/sleep 5
    ${pkgs.syncthingtray-minimal}/bin/syncthingtray widgets-gui --single-instance
  '';
in {
  systemd.user.services.syncthingtray = {
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = lib.mkForce "${syncthingStartScript}/bin/syncthing-start";
      Environment = "QT_QPA_PLATFORM=wayland";
    };
  };
}
