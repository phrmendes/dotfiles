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
      du = getExe ncdu;
      find = getExe fd;
      fs = getExe fselect;
      grep = getExe ripgrep;
      m = "mkdir -p";
      ps = getExe procs;
      sed = getExe gnused;
      top = getExe btop;
      untar = "tar -xvf";
      untargz = "tar -xzf";
      v = "nvim";
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
    };
  };
}
