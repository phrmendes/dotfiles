{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  path = "~/Projects/dotfiles";
  nixos = {
    updateCmd = "sudo nixos-rebuild switch --flake ${path}";
    aliases = {
      dpct = "duplicati-cli";
      open = "xdg-open";
    };
  };
  darwin = {
    update_cmd = "nix run nix-darwin -- switch --flake ${path}";
  };
  updateCmd =
    if isDarwin
    then darwin.updateCmd
    else nixos.updateCmd;
  aliases =
    if isDarwin
    then darwin.aliases
    else nixos.aliases;
in {
  programs = {
    bash.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      initExtra = builtins.readFile ../dotfiles/init.sh;
      shellAliases =
        {
          docker-compose = "podman-compose";
          docker = "podman";
          cat = "bat";
          k = "kubectl";
          lg = "lazygit";
          mkdir = "mkdir -p";
          nc = "nix store gc --debug";
          ncdu = "ncdu --color dark";
          nh = "nix-hash --flat --base64 --type sha256";
          nu = updateCmd;
          v = "nvim";
          zl = "zellij --config ~/.config/zellij/config.kdl";
        }
        // aliases;
    };
  };
}
