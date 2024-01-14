{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    userSettings = builtins.fromJSON (builtins.readFile ../dotfiles/vscode/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ../dotfiles/vscode/keybindings.json);
    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        shfmt
        alejandra
        ansible-lint
        micromamba
        nil
        quarto
      ]);
  };
}
