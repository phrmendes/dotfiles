{
  parameters,
  pkgs,
  ...
}: {
  users.users.${parameters.user} = {
    inherit (parameters) home;
    isNormalUser = true;
    uid = 1000;
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
}
