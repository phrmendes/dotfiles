_: {
  modules.homeManager.workstation.screenshot =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      grim = lib.getExe pkgs.grim;
      slurp = lib.getExe pkgs.slurp;
      satty = lib.getExe pkgs.satty;
      screenshot = pkgs.writeShellScriptBin "screenshot" ''
        ${grim} -g "$(${slurp})" - | ${satty} --filename -
      '';
    in
    {
      home.packages = [
        pkgs.grim
        pkgs.slurp
        pkgs.satty
        screenshot
      ];

      xdg.configFile."satty/config.toml".text = ''
        [general]
        fullscreen = true
        early-exit = true
        initial-tool = "brush"
        copy-command = "${pkgs.wl-clipboard}/bin/wl-copy"
        annotation-size-factor = 2
        output-filename = "${config.home.homeDirectory}/Pictures/screenshot-%Y%m%d%H%M%S.png"
        save-after-copy = false
        default-hide-toolbars = false
      '';
    };
}
