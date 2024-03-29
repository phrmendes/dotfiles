{
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./configuration/apple.nix
    ./configuration/fonts.nix
    ./configuration/homebrew.nix
    ./configuration/packages.nix
  ];

  security.pam.enableSudoTouchIdAuth = true;

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  users.users.${parameters.user} = {
    inherit (parameters) home;
    shell = pkgs.zsh;
  };

  nix = {
    useDaemon = true;
    gc.automatic = true;
    settings.auto-optimise-store = true;
  };
}
