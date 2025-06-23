{
  parameters,
  config,
  ...
}:
{
  users = {
    mutableUsers = true;
    users = {
      root.hashedPasswordFile = config.age.secrets.hashed-password.path;
      ${parameters.user} = {
        inherit (parameters) home;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../dotfiles/ssh-keys/main.txt)
          (builtins.readFile ../../dotfiles/ssh-keys/phone.txt)
        ];
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets.hashed-password.path;
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
