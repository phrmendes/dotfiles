{
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./configuration/fonts.nix
    ./configuration/hardware.nix
    ./configuration/networking.nix
    ./configuration/packages.nix
    ./configuration/programs.nix
    ./configuration/security.nix
    ./configuration/services.nix
    ./configuration/syncthing.nix
    ./configuration/virtualisation.nix
  ];

  console.keyMap = "us";
  sound.enable = true;
  system.stateVersion = "23.11";
  xdg.portal.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "pt_BR.UTF8";
      LC_MEASUREMENT = "pt_BR.UTF8";
      LC_NUMERIC = "pt_BR.UTF8";
    };
  };

  users.users.${parameters.user} = {
    inherit (parameters) home;
    isNormalUser = true;
    uid = 1000;
    initialPassword = "password";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "libvirtd"
    ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = ["flakes" "nix-command"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
