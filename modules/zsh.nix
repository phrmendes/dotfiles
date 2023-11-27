{lib, ...}: let
  path = "~/Projects/bkps";
in {
  programs.zsh = {
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
      mb = "micromamba";
      mba = "micromamba activate";
      mbc = "micromamba create";
      mbd = "micromamba deactivate";
      mbi = "micromamba install";
      mbu = "micromamba update";
      mkdir = "mkdir -p";
      ncdu = "ncdu --color dark";
      nix_clear = "nix store gc --debug";
      nix_hash = "nix-hash --flat --base64 --type sha256";
      nix_update = lib.mkDefault "sudo nixos-rebuild switch --flake ${path}";
      tx = "tmux";
      vim = "nvim";
    };
  };
}
