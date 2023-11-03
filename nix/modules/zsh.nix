{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    initExtra = builtins.readFile ../cfg/init.sh;
    shellAliases = {
      cat = "bat --theme=catppuccin";
      la = "eza --icons -a";
      lg = "lazygit";
      lla = "eza --icons -la";
      ll = "eza --icons -l";
      ls = "eza --icons";
      lt = "eza --icons --tree";
      mba = "micromamba activate";
      mbc = "micromamba create";
      mbd = "micromamba deactivate";
      mbi = "micromamba install";
      mb = "micromamba";
      mkdir = "mkdir -p";
      ncdu = "ncdu --color dark";
      zl = "zellij";
      sys_cat = "/usr/bin/cat";
      sys_ls = "/usr/bin/ls";
      sys_pip = "/usr/bin/pip";
      sys_python = "/usr/bin/python3";
    };
  };
}
