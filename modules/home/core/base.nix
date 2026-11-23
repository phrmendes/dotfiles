{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.base =
    { lib, ... }:
    let
      editor = lib.mkDefault "nvim";
    in
    {
      imports = [ config.flake.modules.homeManager.ssh ];

      stylix.targets.rofi.enable = false;

      home = {
        inherit (settings) stateVersion;
        username = settings.user;
        homeDirectory = settings.home;
        sessionVariables = {
          COLORTERM = "truecolor";
          EDITOR = editor;
          GIT_EDITOR = editor;
          QT_QPA_PLATFORM = "wayland";
          SUDO_EDITOR = editor;
          VISUAL = editor;
        };
      };
    };
}
