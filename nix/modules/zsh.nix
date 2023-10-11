{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    initExtra = builtins.readFile ../cfg/init.sh;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=catppuccin";
      fm = "${pkgs.joshuto}/bin/joshuto";
      la = "${pkgs.eza}/bin/eza --icons -a";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.eza}/bin/eza --icons -l";
      lla = "${pkgs.eza}/bin/eza --icons -la";
      ls = "${pkgs.eza}/bin/eza --icons";
      lt = "${pkgs.eza}/bin/eza --icons --tree";
      mb = "${pkgs.micromamba}/bin/micromamba";
      mba = "${pkgs.micromamba}/bin/micromamba activate";
      mbd = "${pkgs.micromamba}/bin/micromamba deactivate";
      ncdu = "${pkgs.ncdu}/bin/ncdu --color dark";
      tldr = "${pkgs.tealdeer}/bin/tldr";
      tx = "${pkgs.tmux}/bin/tmux";
      zt = "${pkgs.zathura}/bin/zathura --fork";
      mkdir = "mkdir -p";
      of = "fzf_open_with_nvim";
      sys_cat = "/usr/bin/cat";
      sys_ls = "/usr/bin/ls";
      sys_pip = "/usr/bin/pip";
      sys_python = "/usr/bin/python3";
    };
  };
}
