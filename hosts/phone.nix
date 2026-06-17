{ config, ... }:
let
  inherit (config.modules) homeManager;
in
{
  configurations.nix-on-droid.phone.module =
    { lib, pkgs, ... }:
    {
      system.stateVersion = config.settings.stateVersion;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";

        config =
          { ... }:
          {
            home = {
              stateVersion = config.settings.stateVersion;
              username = lib.mkForce "phrmendes";
              homeDirectory = lib.mkForce "/data/data/com.termux.nix/files/home";
              sessionVariables = {
                COLORTERM = "truecolor";
                EDITOR = lib.getExe pkgs.neovim;
                GIT_EDITOR = lib.getExe pkgs.neovim;
                VISUAL = lib.getExe pkgs.neovim;
              };
              packages = with pkgs; [
                curl
                neovim
              ];
            };

            xdg.configFile."nvim/init.lua".source = ../files/neovim/neovim-minimal.lua;

            imports = with homeManager.dev; [
              bat
              eza
              fd
              fzf
              git
              jq
              lazygit
              pi
              ripgrep
              starship
              tealdeer
              tmux
              yazi
              zoxide
              zsh
            ];
          };
      };
    };
}
