{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=catppuccin";
      catr = "/usr/bin/cat";
      fm = "${pkgs.joshuto}/bin/joshuto";
      la = "${pkgs.exa}/bin/exa --icons -a";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.exa}/bin/exa --icons -l";
      lla = "${pkgs.exa}/bin/exa --icons -la";
      ls = "${pkgs.exa}/bin/exa --icons";
      lt = "${pkgs.exa}/bin/exa --icons --tree";
      tldr = "${pkgs.tealdeer}/bin/tldr";
      tx = "${pkgs.tmux}/bin/tmux";
      mkdir = "mkdir -p";
    };
    initExtra = builtins.readFile ../cfg/init.sh;
  };
}
