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
        niri.enable = true;
      };

      environment.systemPackages = [
        pkgs.morewaita-icon-theme
        pkgs.nautilus
      ];

      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      services = {
        geoclue2.enable = true;
        gvfs.enable = true;
        power-profiles-daemon.enable = lib.mkDefault true;
        upower.enable = true;

        greetd = {
          enable = true;
          settings = rec {
            initial_session = {
              inherit (settings) user;
              command = "${lib.getExe' pkgs.niri "niri-session"}";
            };
            default_session = initial_session;
          };
        };
      };

      xdg.portal = {
        enable = true;
        config = {
          common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
          niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "keepassxc";
        };
      };
    };
}
