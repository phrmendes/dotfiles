{
  modules.homeManager.workstation.gnupg =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pinentry-gnome3 ];

      programs.gpg = {
        enable = true;
        settings = {
          use-agent = true;
          no-symkey-cache = true;
        };
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = false;
        pinentry.package = pkgs.pinentry-gnome3;
        defaultCacheTtl = 1800;
        maxCacheTtl = 7200;
      };
    };
}
