{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.workstation.hyprland =
    { lib, pkgs, ... }:
    {
      programs = {
        dconf.enable = true;
        hyprland.enable = true;
        hyprland.withUWSM = true;
      };

      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            inherit (settings) user;
            command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
          };
          default_session = initial_session;
        };
      };
    };
}
