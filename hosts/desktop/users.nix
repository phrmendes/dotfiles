{
  parameters,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = true;
    users = {
      root.hashedPasswordFile = "password";
      ${parameters.user} = {
        inherit (parameters) home;
        isNormalUser = true;
        hashedPasswordFile = "password";
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
  };
}
