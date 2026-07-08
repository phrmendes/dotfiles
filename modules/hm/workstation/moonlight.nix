_: {
  modules.homeManager.workstation.moonlight =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ moonlight-qt ];
    };
}
