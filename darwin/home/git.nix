{lib, ...}: {
  programs.git = {
    userEmail = lib.mkForce "pedro.mendes-ext@ab-inbev.com";
  };
}
