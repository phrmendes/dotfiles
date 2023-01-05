{ config, pkgs, ... }:

let
  user = "prochame";
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/Users/${user}";
      packages = with pkgs;
        [
          pandoc
          gnused
          bat
          lazygit
          sd
          tealdeer
          shellcheck
          ranger
          stow
          exa
          python3Full
          cargo
          go
          nodejs
          podman
          neovim
          terraform
          terragrunt
          tflint
          qemu
          texlive.combined.scheme-minimal
        ];
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "lunarvim";
      };
    };
    programs = {
      git = {
        enable = true;
        userName = "Pedro Mendes";
        userEmail = "phrmendes@tuta.io";
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      bat = {
        enable = true;
        config.theme = "Nord";
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
