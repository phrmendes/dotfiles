_: {
  modules.nixos.core.programs =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (config.machine) isWorkstation;
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
