{
  hm.moonlight =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ moonlight-qt ];
    };
}
