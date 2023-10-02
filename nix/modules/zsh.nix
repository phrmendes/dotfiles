{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=catppuccin";
      fm = "${pkgs.joshuto}/bin/joshuto";
      la = "${pkgs.eza}/bin/eza --icons -a";
      ld = "${pkgs.lazydocker}/bin/lazydocker";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.eza}/bin/eza --icons -l";
      lla = "${pkgs.eza}/bin/eza --icons -la";
      ls = "${pkgs.eza}/bin/eza --icons";
      lt = "${pkgs.eza}/bin/eza --icons --tree";
      ncdu = "${pkgs.ncdu}/bin/ncdu --color dark";
      tldr = "${pkgs.tealdeer}/bin/tldr";
      tx = "${pkgs.tmux}/bin/tmux";
      zt = "${pkgs.zathura}/bin/zathura --fork";
      mb = "micromamba";
      mkdir = "mkdir -p";
      od = "nvim +ObsidianToday";
      of = "fzf_open_with_nvim";
      os = "nvim +ObsidianSearch";
      sys_cat = "/usr/bin/cat";
      sys_ls = "/usr/bin/ls";
      sys_pip = "/usr/bin/pip";
      sys_python = "/usr/bin/python3";
    };
    initExtra = builtins.readFile ../cfg/init.sh;
  };
}
