{
  lib,
  config,
  ...
}: {
  options.atuin.enable = lib.mkEnableOption "enable atuin";

  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        enter_accept = false;
        keymap_mode = "vim-insert";
        filter_mode_shell_up_key_binding = "session";
      };
      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
