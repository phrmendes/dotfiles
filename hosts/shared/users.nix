{
  parameters,
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = true;
    users = {
      ${parameters.user} = {
        inherit (parameters) home;
        shell = pkgs.fish;
        initialPassword = "password";
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../dotfiles/ssh-keys/main.txt)
          (builtins.readFile ../../dotfiles/ssh-keys/phone.txt)
          (builtins.readFile ../../dotfiles/ssh-keys/laptop.txt)
          (builtins.readFile ../../dotfiles/ssh-keys/server.txt)
        ];
        isNormalUser = true;
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
