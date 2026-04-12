_: {
  modules.nixos.core.programs =
    { pkgs, config, lib, ... }:
    {
      programs = {
        nano.enable = false;
        fuse.userAllowOther = true;
        command-not-found.enable = false;
        zsh.enable = true;

        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            glib
            libGL
            libxxf86vm
          ];
        };

        gnupg.agent = {
          enable = true;
          enableBrowserSocket = true;
          pinentryPackage = if config.machine.type == "server" then pkgs.pinentry-curses else pkgs.pinentry-gnome3;
        };

        ssh = lib.mkIf (config.machine.type != "server") {
          startAgent = true;
          askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
        };

        nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep-since 3d --keep 5";
          };
        };
      };
    };
}
