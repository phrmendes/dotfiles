{ inputs, ... }:
{
  modules = {
    nixos.core.system-packages =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          [
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            cachix
            coreutils-full
            dig
            egl-wayland
            file
            findutils
            gcc
            gnumake
            gnused
            gzip
            lsof
            mlocate
            openssl
            p7zip
            psmisc
            rar
            unar
            unzip
            wget
            wl-clipboard
            xdg-utils
            zip
          ]
          ++ (with pkgs.unixtools; [
            net-tools
            netstat
          ])
          ++ lib.optionals (config.machine.type != "server") [
            docker-credential-helpers
            libsecret
          ];
      };
  };
}
