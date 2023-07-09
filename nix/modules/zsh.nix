{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=gruvbox-dark";
      catr = "/usr/bin/cat";
      la = "${pkgs.exa}/bin/exa --icons -a";
      ld = "${pkgs.lazydocker}/bin/lazydocker";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.exa}/bin/exa --icons -l";
      lla = "${pkgs.exa}/bin/exa --icons -la";
      ls = "${pkgs.exa}/bin/exa --icons";
      lt = "${pkgs.exa}/bin/exa --icons --tree";
      tldr = "${pkgs.tealdeer}/bin/tldr";
      mkdir = "mkdir -p";
    };
    initExtra = builtins.readFile ../cfg/init.zsh;
  };
}
