{parameters, ...}: let
  colors = import ../../shared/catppuccin.nix;
in {
  xserver = {
    enable = true;
    autorun = true;
    xkb.layout = "us,br";
    videoDrivers = ["nvidia"];
    displayManager.lightdm.greeters.mini = {
      inherit (parameters) user;
      enable = true;
      extraConfig = with colors.catppuccin.pallete; ''
        [greeter]
        show-password-label = true
        password-label-text = Password:
        invalid-password-text = Invalid password
        show-input-cursor = true
        password-alignment = left
        show-sys-info = true

        [greeter-hotkeys]
        mod-key = meta
        shutdown-key = s
        restart-key = r
        suspend-key = u
        session-key = e

        [greeter-theme]
        font = "Fira Sans"
        font-size = 1em
        font-weight = bold
        font-style = normal
        text-color = "#${text}"
        error-color = "#${red}"
        background-image = ""
        background-color = "#${base}"
        window-color = "#${base}"
        border-color = "#${blue}"
        border-width = 2px
        layout-space = 15
        password-character = -1
        password-color = "#${text}"
        password-background-color = "#${text}"
        password-border-color = "#${blue}"
        password-border-width = 2px
        password-border-radius = 0.341125em
        sys-info-font = "Sans"
        sys-info-font-size = 0.8em
        sys-info-margin = -5px -5px -5px
      '';
    };
  };
}
