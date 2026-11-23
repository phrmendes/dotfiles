{
  flake.modules.homeManager.librewolf =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      profileDir = "${config.xdg.configHome}/librewolf/librewolf";
    in
    {
      stylix.targets.librewolf.profileNames = [ "default" ];

      programs.librewolf = {
        enable = true;
        package = pkgs.librewolf-bin;
        configPath = profileDir;
        nativeMessagingHosts = with pkgs; [ keepassxc ];
        policies.Certificates.Install = [ "${../../../files/ca.crt}" ];
      };

      home.file."${profileDir}/profiles.ini".enable = lib.mkForce false;

      xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".source = ../../../files/librewolf.cfg;
    };
}
