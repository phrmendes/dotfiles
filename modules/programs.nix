_: {
  modules.nixos.core.programs =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      isWorkstation = config.machine.type == "desktop" || config.machine.type == "laptop";
    in
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
          pinentryPackage = if isWorkstation then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
        };

        ssh = lib.mkIf isWorkstation {
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
