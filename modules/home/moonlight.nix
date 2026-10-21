{
  flake.modules.homeManager.moonlight =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ moonlight-qt ];
    };
}
