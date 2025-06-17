{
  parameters,
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = true;
    users = {
      root.initialPassword = "password";
      ${parameters.user} = {
        inherit (parameters) home;
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../dotfiles/public-key.txt) ];
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.zsh;
        uid = 1000;
        extraGroups = [
          "audio"
          "docker"
          "libvirtd"
          "networkmanager"
          "video"
          "wheel"
        ];
      };
    };
  };
}
