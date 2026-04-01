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
        shell = pkgs.zsh;
        initialPassword = "password";
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../files/ssh-keys/main.txt)
          (builtins.readFile ../../files/ssh-keys/phone.txt)
          (builtins.readFile ../../files/ssh-keys/laptop.txt)
          (builtins.readFile ../../files/ssh-keys/server.txt)
        ];
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "adbusers"
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
