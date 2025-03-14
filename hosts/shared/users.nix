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
        isNormalUser = true;
        initialPassword = "password";
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
