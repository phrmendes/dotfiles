{pkgs, ...}: let
  path = "~/Projects/bkps";
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
        cat = "bat --theme=catppuccin";
        la = "eza --icons -a";
        lg = "lazygit";
        ll = "eza --icons -l";
        lla = "eza --icons -la";
        ls = "eza --icons";
        lt = "eza --icons --tree";
        mkdir = "mkdir -p";
        ncdu = "ncdu --color dark";
        nix_clear = "nix store gc --debug";
        nix_hash = "nix-hash --flat --base64 --type sha256";
        nix_update = update_command;
        tx = "tmux";
        v = "nvim";
      };
    };
  };
}
