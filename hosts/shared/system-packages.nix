{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      inputs.agenix.packages.${pkgs.system}.default
      android-udev-rules
      cachix
      coreutils-full
      dig
      docker-compose
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
