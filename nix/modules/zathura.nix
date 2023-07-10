{
  programs.zathura = {
    enable = true;
    extraConfig = builtins.readFile ../cfg/zathurarc;
  };
}
