{pkgs, ...}: let
  path = "~/Projects/dotfiles";
  update_command =
    if pkgs.stdenv.isDarwin
    then "nix run nix-darwin -- switch --flake ${path}"
    else "sudo nixos-rebuild switch --flake ${path}";
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
      shellAliases = {
        cat = "bat";
        lg = "lazygit";
        mkdir = "mkdir -p";
        nc = "nix store gc --debug";
        ncdu = "ncdu --color dark";
        nh = "nix-hash --flat --base64 --type sha256";
        nu = update_command;
        t = "tmux";
        tka = "tmux kill-session -a";
        tn = "tmux new -s $(pwd | sed 's/.*\///g')";
        v = "nvim";
      };
    };
  };
}
