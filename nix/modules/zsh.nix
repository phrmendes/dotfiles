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
      mkdir = "mkdir -p";
      nix_clean = "nix-collect-garbage";
      nix_update = "home-manager switch";
      system_clean = "sudo apt autoremove -y && sudo apt autoclean -y && flatpak uninstall --unused -y";
      system_update = "sudo apt update && sudo apt dist-upgrade -y && flatpak update -y";
      tldr = "${pkgs.tealdeer}/bin/tldr";
    };
    initExtra = builtins.readFile ../cfg/init.zsh;
  };
}
