_: {
  modules.nixos.workstation.greetd =
    { pkgs, lib, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --time --cmd '${lib.getExe pkgs.uwsm} start -- hyprland-uwsm.desktop'";
            user = "greeter";
          };
        };
      };
    };
}
