{
  homeModules.sesh =
    { pkgs, config, ... }:
    {
      programs.sesh = {
        enable = true;
        enableAlias = true;
        enableTmuxIntegration = true;
        tmuxKey = "s";
        settings.frecency.list_command = "${pkgs.fd}/bin/fd --hidden --no-ignore --type d ^\\.git$ ${config.home.homeDirectory}/Projects --format {//}";
      };
    };
}
