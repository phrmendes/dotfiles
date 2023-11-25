{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    <home-manager/nix-darwin>
    ./modules/apple.nix
    ./modules/homebrew.nix
  ];
  environment.systemPackages = [pkgs.home-manager];
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  users.users.prochame = {
    home = "/Users/prochame";
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.prochame = {
      imports = [
        ../../modules/bat.nix
        ../../modules/direnv.nix
        ../../modules/fzf.nix
        ../../modules/git.nix
        ../../modules/lazygit.nix
        ../../modules/neovim.nix
        ../../modules/starship.nix
        ../../modules/tmux.nix
        ../../modules/zoxide.nix
        ../../modules/zsh.nix
        ./modules/dotfiles.nix
        ./modules/packages.nix
      ];
      home = {
        username = "prochame";
        homeDirectory = "/Users/prochame";
        stateVersion = "23.05";
        sessionVariables = {
          EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
      programs.git.userEmail = lib.mkForce "pedrohrmendes@proton.me";
    };
  };
}
