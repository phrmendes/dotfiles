{ inputs, ... }:
{
  modules.nixos.core.packages =
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
          curl
          dig
          docker-credential-helpers
          egl-wayland
          file
          findutils
          gcc
          gnumake
          gnused
          gzip
          lsof
          mlocate
          nodejs_latest
          openssl
          p7zip
          psmisc
          python314
          rar
          sqlite
          unar
          unzip
          wget
          xdg-utils
          zip
        ]
        ++ (with pkgs.unixtools; [
          net-tools
          netstat
        ])
        ++ lib.optionals config.machine.isWorkstation [
          libsecret
        ];
    };
}
