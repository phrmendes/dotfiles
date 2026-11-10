_: {
  flake.modules.nixos.mosh = {
    programs.mosh.enable = true;
    environment.sessionVariables.MOSH_SERVER_NETWORK_TMOUT = "600";
  };
}
