{
  config,
  parameters,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = true;
    root = {
      initialPassword = "password";
      hashedPasswordFile = config.sops.secrets.admin.path;
    };
    ${parameters.user} = {
      inherit (parameters) home;
      isNormalUser = true;
      initialPassword = "password";
      hashedPasswordFile = config.sops.secrets.admin.path;
      shell = pkgs.zsh;
      uid = 1000;
      extraGroups = [
        "audio"
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
}
