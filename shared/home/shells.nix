{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  path = "~/Projects/dotfiles";
  nixos = {
    updateCmd = "sudo nixos-rebuild switch --flake ${path}";
    aliases = {
      dpct = "duplicati-cli";
      open = "xdg-open";
      ld = "lazydocker";
    };
  };
  darwin = {
    updateCmd = "nix run nix-darwin -- switch --flake ${path}";
    aliases = {
      docker-compose = "podman-compose";
      docker = "podman";
    };
  };
  updateCmd =
    if isDarwin
    then darwin.updateCmd
    else nixos.updateCmd;
  condAliases =
    if isDarwin
    then darwin.aliases
    else nixos.aliases;
  aliases =
    {
      cat = "${pkgs.bat}/bin/bat";
      k = "${pkgs.kubectl}/bin/kubectl";
      lg = "${pkgs.lazygit}/bin/lazygit";
      mkdir = "mkdir -p";
      nc = "nix store gc --debug";
      ncdu = "${pkgs.ncdu}/bin/ncdu --color dark";
      nh = "nix-hash --flat --base64 --type sha256";
      nu = updateCmd;
      v = "nvim";
      zl = "${pkgs.zellij}/bin/zellij";
    }
    // condAliases;
in {
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      shellAliases = aliases;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      initExtra = builtins.readFile ../../dotfiles/init.sh;
      shellAliases = aliases;
    };
  };
}
