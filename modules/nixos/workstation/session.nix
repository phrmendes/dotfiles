{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.session =
    { lib, pkgs, ... }:
    {
      programs = {
        dconf.enable = true;
        ssh = {
          startAgent = true;
          askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
        };
        hyprland = {
          enable = true;
          withUWSM = true;
        };
        thunar = {
          enable = true;
          plugins = with pkgs; [ thunar-volman ];
        };
      };

      services = {
        flatpak = {
          enable = true;
          packages = [
            "org.zotero.Zotero"
            "com.stremio.Stremio"
          ];
        };
        geoclue2.enable = true;
        gvfs.enable = true;
        power-profiles-daemon.enable = lib.mkDefault true;
        upower.enable = true;

        greetd = {
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

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config.hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
    };
}
