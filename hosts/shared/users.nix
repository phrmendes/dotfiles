{ parameters, pkgs, ... }:
{
  users = {
    mutableUsers = true;
    users = {
      root.initialPassword = "password";
      ${parameters.user} = {
        inherit (parameters) home;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../dotfiles/ssh-keys/main.txt)
          (builtins.readFile ../../dotfiles/ssh-keys/phone.txt)
        ];
        isNormalUser = true;
        initialPassword = "password";
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
