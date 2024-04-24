{
  parameters,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      root.initialPassword = "password";
      ${parameters.user} = {
        inherit (parameters) home;
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.zsh;
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
