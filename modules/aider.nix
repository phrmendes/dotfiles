{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.aider.enable = lib.mkEnableOption "enable aider";

  config = lib.mkIf config.aider.enable {

    home.packages = with pkgs; [
      aider-chat
    ];

    xdg.configFile.".aider.conf.yml".text = ''
      editor: vim
      code-theme: gruvbox-dark
      dark-mode: true
      theme: gruvbox
      attribute-committer: false
      attribute-author: false
      auto-commits: false
    '';
  };
}
