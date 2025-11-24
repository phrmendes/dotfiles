{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      inputs.agenix.packages.${pkgs.system}.default
      cachix
      coreutils-full
      dig
      docker-compose
      egl-wayland
      file
      findutils
      gcc
      gnumake
      gnused
      gzip
      libsecret
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
    ]);
}
