{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) getExe;
  path = "~/Projects/dotfiles";
  nixos = {
    updateCmd = "sudo nixos-rebuild switch --flake ${path}";
    aliases = {
      dpct = "duplicati-cli";
      open = "xdg-open";
    };
  };
  darwin = {
    updateCmd = "nix run nix-darwin -- switch --flake ${path}";
  };
  updateCmd =
    if isDarwin
    then darwin.updateCmd
    else nixos.updateCmd;
  condAliases =
    if isDarwin
    then darwin.aliases
    else nixos.aliases;
  aliases = with pkgs;
    {
      cat = getExe bat;
      du = getExe du-dust;
      grep = getExe ripgrep;
      lg = getExe lazygit;
      m = "mkdir -p";
      nc = "nix store gc --debug";
      nh = "nix-hash --flat --base64 --type sha256";
      nu = updateCmd;
      ps = getExe procs;
      top = getExe btop;
      untar = "tar -xvf";
      untargz = "tar -xzf";
      v = "nvim";
      zl = getExe zellij;
    }
    // condAliases;
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
      plugins = with pkgs; [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = inputs.zsh-nix-shell;
        }
      ];
    };
  };
}
