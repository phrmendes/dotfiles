_: {
  modules.homeManager.dev.alacritty =
    { pkgs, lib, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell = {
            program = lib.getExe pkgs.tmux;
            args = [
              "new-session"
              "-A"
              "-s"
              "default"
            ];
          };
          window = {
            dynamic_padding = true;
            padding = {
              x = 8;
              y = 8;
            };
            decorations = "None";
          };
          cursor.style = {
            shape = "Block";
            blinking = "Off";
          };
          keyboard.bindings = [
            {
              key = "C";
              mods = "Control|Shift";
              action = "Copy";
            }
            {
              key = "V";
              mods = "Control|Shift";
              action = "Paste";
            }
            {
              key = "Plus";
              mods = "Control|Shift";
              action = "IncreaseFontSize";
            }
            {
              key = "Minus";
              mods = "Control";
              action = "DecreaseFontSize";
            }
            {
              key = "Key0";
              mods = "Control";
              action = "ResetFontSize";
            }
          ];
        };
      };
    };
}
