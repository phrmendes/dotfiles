{
  parameters,
  lib,
  inputs,
  ...
}:

{
  imports = [
    (inputs.import-tree ./modules)
  ];

  qt.platformTheme.name = lib.mkForce "adwaita";

  home = {
    stateVersion = "26.05";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
    };
  };
}
