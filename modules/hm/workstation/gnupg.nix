{ pkgs, ... }:
{
  modules.homeManager.workstation.gnupg = {
    programs.gpg = {
      enable = true;
      settings = {
        use-agent = true;
        no-symkey-cache = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      # SSH agent is handled by KeePassXC (SSHAgent.Enabled)
      enableSshSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
    };
  };
}
