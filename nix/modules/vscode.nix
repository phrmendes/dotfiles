{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    keybindings = builtins.fromJSON (builtins.readFile ../cfg/vscode/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../cfg/vscode/settings.json);
  };
}
