{
  homeModules.librewolf =
    { pkgs, ... }:
    {
      programs.librewolf = {
        enable = true;
        package = pkgs.librewolf-bin;
        nativeMessagingHosts = with pkgs; [ keepassxc ];
      };

      xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source = ../../files/librewolf.cfg;
    };
}
