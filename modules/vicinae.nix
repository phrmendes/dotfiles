_: {
  modules.homeManager.workstation.vicinae =
    { pkgs, lib, ... }:
    {
      programs.vicinae = {
        enable = true;
        package = pkgs.stable.vicinae;
        systemd.enable = true;
      };

      home.activation.vicinae-refresh-apps = lib.mkForce (lib.hm.dag.entryAfter [ "installPackages" ] "");
    };
}
