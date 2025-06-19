{
  pkgs,
  config,
  lib,
  parameters,
  ...
}:
{
  imports = [
    ../shared
    ./age.nix
    ./systemd.nix
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  networking.hostName = "server";
  programs.nh.flake = "/home/${parameters.user}/dotfiles";

  environment.systemPackages = with pkgs; [
    python313
    helix
  ];

  services = {
    tailscale = {
      useRoutingFeatures = "both";
      extraSetFlags = [ "--advertise-exit-node" ];
    };
  };

  home-manager.users.${parameters.user} = {
    blueman-applet.enable = false;
    cliphist.enable = false;
    direnv.enable = false;
    dunst.enable = false;
    gh.enable = false;
    ghostty.enable = false;
    gtk-settings.enable = false;
    hypridle.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    hyprpaper.enable = false;
    imv.enable = false;
    k9s.enable = false;
    keepassxc.enable = false;
    lazydocker.enable = false;
    lazygit.enable = false;
    mpv.enable = false;
    neovim.enable = false;
    nm-applet.enable = false;
    packages.enable = false;
    pasystray.enable = false;
    screenshot.enable = false;
    swayosd.enable = false;
    symlinks.enable = false;
    syncthingtray.enable = false;
    tealdeer.enable = false;
    udiskie.enable = false;
    uv.enable = false;
    waybar.enable = false;
    wofi.enable = false;
    zathura.enable = false;
  };

  environment = {
    persistence."/persist".users.${parameters.user}.directories = [
      "dotfiles"
      ".config"
      ".ssh"
      ".zotero"
      ".local/share"
      ".local/state"
    ];
    etc = {
      "compose/Caddyfile" = {
        source = ../../dotfiles/compose/Caddyfile;
        mode = "0644";
      };
      "compose/docker-compose.yaml" = {
        source = ../../dotfiles/compose/docker-compose.yaml;
        mode = "0644";
      };
    };
  };

}
