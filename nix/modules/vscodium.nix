{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # keybindings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/keybindings.json);
    # userSettings = builtins.fromJSON (builtins.readFile ../cfg/vscodium/settings.json);
  };
}
