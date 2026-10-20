{
  homeModules.librewolf =
    { pkgs, ... }:
    {
      programs.librewolf = {
        enable = true;
        package = pkgs.librewolf-bin;
        nativeMessagingHosts = with pkgs; [ keepassxc ];
        policies.Certificates.ImportEnterpriseRoots = true;
      };

      xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source = ../../files/librewolf.cfg;
    };
}
