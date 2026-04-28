{ config, inputs, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.home-manager =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = { inherit inputs; };
      };
    };

  modules.homeManager.user.base =
    { lib, ... }:
    let
      editor = lib.mkOverride 1001 "nvim";
    in
    {
      imports = [ inputs.nix-index-database.homeModules.default ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*".addKeysToAgent = "no";
          "server" = {
            hostname = "server.codlet-catfish.ts.net";
            user = settings.user;
          };
          "dev" = {
            hostname = "server.codlet-catfish.ts.net";
            user = settings.user;
            port = 2222;
          };
        };
      };

      home = {
        stateVersion = "26.05";
        username = settings.user;
        homeDirectory = settings.home;
        sessionVariables = {
          EDITOR = editor;
          GIT_EDITOR = editor;
          SUDO_EDITOR = editor;
          VISUAL = editor;
        };
      };
    };
}
