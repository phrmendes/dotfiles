{
  homeModules.librewolf =
    { pkgs, ... }:
    {
      programs.librewolf = {
        enable = true;
        package = pkgs.librewolf-bin;
        nativeMessagingHosts = with pkgs; [ keepassxc ];
        policies.Certificates.Install = [ "${../../files/ca.crt}" ];
      };

      xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source = ../../files/librewolf.cfg;
    };
}
