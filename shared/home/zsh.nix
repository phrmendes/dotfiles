{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) getExe;
  path = "~/Projects/dotfiles";
  aliases = with pkgs;
    {
      cat = getExe bat;
      du = getExe du-dust;
      find = getExe fd;
      grep = getExe ripgrep;
      lg = getExe lazygit;
      m = "mkdir -p";
      ps = getExe procs;
      sed = getExe gnused;
      top = getExe btop;
      untar = "tar -xvf";
      untargz = "tar -xzf";
      v = "nvim";
      zl = getExe zellij;
    }
    // (
      if ! isDarwin
      then {
        dpct = "duplicati-cli";
        open = "xdg-open";
      }
      else {}
    );
in {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      initExtra = builtins.readFile ../../dotfiles/init.sh;
      shellAliases = aliases;
      dirHashes = {
        docs = "$HOME/Documents";
        notes = "$HOME/Documents/notes";
        dots = "$HOME/Projects/dotfiles";
        dl = "$HOME/download";
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.zsh-nix-shell;
        }
      ];
    };
  };
}
