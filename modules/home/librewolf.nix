{
  homeModules.librewolf =
    { config, pkgs, ... }:
    {
      programs.librewolf = {
        enable = true;
        package = pkgs.librewolf-bin;
        nativeMessagingHosts = [ pkgs.keepassxc ];
        settings = {
          "identity.fxaccounts.enabled" = true;
          "services.sync.engine.addons" = true;
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "media.autoplay.default" = 1;
          "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
          "browser.download.folderList" = 2;
          "ui.systemUsesDarkTheme" = 1;
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
        };
      };
    };
}
