{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
  path = "~/Projects/dotfiles";
  nixos = {
    update_cmd = "sudo nixos-rebuild switch --flake ${path}";
    aliases = {
      dpct = "duplicati-cli";
      ld = "lazydocker";
      open = "xdg-open";
    };
  };
  darwin = {
    update_cmd = "nix run nix-darwin -- switch --flake ${path}";
    aliases = {
      docker = "podman";
    };
  };
  update_cmd =
    if isDarwin
    then darwin.update_cmd
    else nixos.update_cmd;
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
          cat = "bat";
          lg = "lazygit";
          mkdir = "mkdir -p";
          nc = "nix store gc --debug";
          ncdu = "ncdu --color dark";
          nh = "nix-hash --flat --base64 --type sha256";
          nu = update_cmd;
          v = "nvim";
        }
        // aliases;
    };
  };
}
