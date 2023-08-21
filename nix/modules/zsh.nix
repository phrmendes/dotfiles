{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=catppuccin";
      fm = "${pkgs.joshuto}/bin/joshuto";
      la = "${pkgs.exa}/bin/exa --icons -a";
      ld = "${pkgs.lazydocker}/bin/lazydocker";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.exa}/bin/exa --icons -l";
      lla = "${pkgs.exa}/bin/exa --icons -la";
      ls = "${pkgs.exa}/bin/exa --icons";
      lt = "${pkgs.exa}/bin/exa --icons --tree";
      tldr = "${pkgs.tealdeer}/bin/tldr";
      tx = "${pkgs.tmux}/bin/tmux";
      ncdu = "${pkgs.ncdu}/bin/ncdu --color dark";
      zt = "${pkgs.zathura}/bin/zathura --fork";
      mkdir = "mkdir -p";
      sys_cat = "/usr/bin/cat";
      sys_pip = "/usr/bin/pip";
      sys_ls = "/usr/bin/ls";
      sys_python = "/usr/bin/python3";
    };
    initExtra = builtins.readFile ../cfg/init.sh;
  };
}
