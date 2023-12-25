{pkgs, ...}: let
  path = "~/Projects/dotfiles";
  nixos = {
    update = "nix run nixpkgs.nixos-rebuild -- switch --flake ${path}";
    aliases = {
      ld = "lazydocker";
      bkp = "duplicati-server";
    };
  };
  darwin = {
    update = "nix run nixpkgs.nix-darwin -- switch --flake ${path}";
    aliases = {
      docker = "podman";
    };
  };
  update_cmd =
    if pkgs.stdenv.isDarwin
    then nixos.update
    else darwin.update;
  aliases =
    if pkgs.stdenv.isDarwin
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
          t = "tmux";
          tka = "tmux kill-session -a";
          tn = "tmux new -s $(pwd | sed 's/.*\///g')";
          v = "nvim";
        }
        // aliases;
    };
  };
}
