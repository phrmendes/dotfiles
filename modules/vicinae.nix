_: {
  modules.homeManager.workstation.vicinae =
    { pkgs, lib, ... }:
    {
      programs.vicinae = {
        enable = true;
        package = pkgs.vicinae;
        systemd.enable = true;
        settings.theme = lib.mkForce {
          dark.name = "stylix";
          light.name = "stylix";
        };
      };

      systemd.user.services.vicinae = {
        Unit.After = [ "graphical-session.target" ];
        Service.Environment = [ "QT_QPA_PLATFORM=wayland" ];
      };

      home.activation.vicinae-refresh-apps = lib.mkForce (lib.hm.dag.entryAfter [ "installPackages" ] "");
    };
}
