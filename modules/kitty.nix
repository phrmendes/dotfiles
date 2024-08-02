{
  lib,
  config,
  pkgs,
  ...
}: {
  options.kitty.enable = lib.mkEnableOption "enable kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      settings = let
        inherit (pkgs.stdenv) isLinux;
      in {
        allow_remote_control = "yes";
        bell_on_tab = "no";
        enable_audio_bell = "no";
        enabled_layouts = "splits:split_axis=horizontal,stack";
        inactive_text_alpha = "0.9";
        listen_on =
          if isLinux
          then "unix:@kitty"
          else "unix:/tmp/kitty";
        macos_option_as_alt = "yes";
        open_url_with = "default";
        scrollback_lines = 10000;
        shell_integration = "enabled";
        tab_bar_edge = "bottom";
        tab_bar_min_tabs = 2;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' #{}'.format(num_windows) if num_windows > 1 else ''}";
        term = "xterm-256color";
        undercurl_style = "thin-sparse";
        update_check_interval = 0;
        window_padding_width = 5;
        hide_window_decorations =
          if isLinux
          then "yes"
          else "no";
      };
      extraConfig = ''
        map --when-focus-on var:IS_NVIM ctrl+h
        map --when-focus-on var:IS_NVIM ctrl+j
        map --when-focus-on var:IS_NVIM ctrl+k
        map --when-focus-on var:IS_NVIM ctrl+l
        map --when-focus-on var:IS_NVIM ctrl+shift+h
        map --when-focus-on var:IS_NVIM ctrl+shift+j
        map --when-focus-on var:IS_NVIM ctrl+shift+k
        map --when-focus-on var:IS_NVIM ctrl+shift+l
      '';
      keybindings = {
        "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
        "ctrl+shift+enter" = "layout_action rotate";
        "ctrl+shift+n" = "new_tab";
        "ctrl+shift+q" = "close_window";
        "ctrl+shift+t" = ''set_tab_title " "'';
        "ctrl+shift+z" = "toggle_layout stack";
        "ctrl+shift+[" = "previous_tab";
        "ctrl+shift+]" = "next_tab";
        "ctrl+h" = "neighboring_window left";
        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+l" = "neighboring_window right";
        "ctrl+shift+h" = "kitten relative_resize.py left 3";
        "ctrl+shift+j" = "kitten relative_resize.py down 3";
        "ctrl+shift+k" = "kitten relative_resize.py up 3";
        "ctrl+shift+l" = "kitten relative_resize.py right 3";
      };
    };

    home.file = {
      ".config/kitty/neighboring_window.py".text =
        /*
        python
        */
        ''
          from kitty.key_encoding import KeyEvent, parse_shortcut
          from kittens.tui.handler import result_handler


          def main():
              pass


          def encode_key_mapping(window, key_mapping):
              mods, key = parse_shortcut(key_mapping)
              event = KeyEvent(
                  mods=mods,
                  key=key,
                  shift=bool(mods & 1),
                  alt=bool(mods & 2),
                  ctrl=bool(mods & 4),
                  super=bool(mods & 8),
                  hyper=bool(mods & 16),
                  meta=bool(mods & 32),
              ).as_window_system_event()

              return window.encoded_key(event)


          @result_handler(no_ui=True)
          def handle_result(args, result, target_window_id, boss):
              window = boss.window_id_map.get(target_window_id)

              cmd = window.child.foreground_cmdline[0]
              if cmd == "tmux":
                  keymap = args[2]
                  encoded = encode_key_mapping(window, keymap)
                  window.write_to_child(encoded)
              else:
                  boss.active_tab.neighboring_window(args[1])
        '';
      ".config/kitty/relative_resize.py".text =
        /*
        python
        */
        ''
          from kittens.tui.handler import result_handler
          from kitty.key_encoding import KeyEvent, parse_shortcut


          def encode_key_mapping(window, key_mapping):
              mods, key = parse_shortcut(key_mapping)
              event = KeyEvent(
                  mods=mods,
                  key=key,
                  shift=bool(mods & 1),
                  alt=bool(mods & 2),
                  ctrl=bool(mods & 4),
                  super=bool(mods & 8),
                  hyper=bool(mods & 16),
                  meta=bool(mods & 32),
              ).as_window_system_event()

              return window.encoded_key(event)


          def main(args):
              pass


          def relative_resize_window(direction, amount, target_window_id, boss):
              window = boss.window_id_map.get(target_window_id)
              if window is None:
                  return

              neighbors = boss.active_tab.current_layout.neighbors_for_window(
                  window, boss.active_tab.windows
              )
              current_window_id = boss.active_tab.active_window

              left_neighbors = neighbors.get('left')
              right_neighbors = neighbors.get('right')
              top_neighbors = neighbors.get('top')
              bottom_neighbors = neighbors.get('bottom')

              # has a neighbor on both sides
              if direction == 'left' and (left_neighbors and right_neighbors):
                  boss.active_tab.resize_window('narrower', amount)
              # only has left neighbor
              elif direction == 'left' and left_neighbors:
                  boss.active_tab.resize_window('wider', amount)
              # only has right neighbor
              elif direction == 'left' and right_neighbors:
                  boss.active_tab.resize_window('narrower', amount)

              # has a neighbor on both sides
              elif direction == 'right' and (left_neighbors and right_neighbors):
                  boss.active_tab.resize_window('wider', amount)
              # only has left neighbor
              elif direction == 'right' and left_neighbors:
                  boss.active_tab.resize_window('narrower', amount)
              # only has right neighbor
              elif direction == 'right' and right_neighbors:
                  boss.active_tab.resize_window('wider', amount)

              # has a neighbor above and below
              elif direction == 'up' and (top_neighbors and bottom_neighbors):
                  boss.active_tab.resize_window('shorter', amount)
              # only has top neighbor
              elif direction == 'up' and top_neighbors:
                  boss.active_tab.resize_window('taller', amount)
              # only has bottom neighbor
              elif direction == 'up' and bottom_neighbors:
                  boss.active_tab.resize_window('shorter', amount)

              # has a neighbor above and below
              elif direction == 'down' and (top_neighbors and bottom_neighbors):
                  boss.active_tab.resize_window('taller', amount)
              # only has top neighbor
              elif direction == 'down' and top_neighbors:
                  boss.active_tab.resize_window('shorter', amount)
              # only has bottom neighbor
              elif direction == 'down' and bottom_neighbors:
                  boss.active_tab.resize_window('taller', amount)


          @result_handler(no_ui=True)
          def handle_result(args, result, target_window_id, boss):
              direction = args[1]
              amount = int(args[2])
              window = boss.window_id_map.get(target_window_id)

              cmd = window.child.foreground_cmdline[0]
              if cmd == 'tmux':
                  keymap = args[3]
                  encoded = encode_key_mapping(window, keymap)
                  window.write_to_child(encoded)
              else:
                  relative_resize_window(direction, amount, target_window_id, boss)
        '';
      ".config/kitty/split_window.py".text =
        /*
        python
        */
        ''
          from kittens.tui.handler import result_handler
          from kitty.key_encoding import KeyEvent, parse_shortcut


          def main(args):
              pass


          def encode_key_mapping(window, key_mapping):
              mods, key = parse_shortcut(key_mapping)
              event = KeyEvent(
                  mods=mods,
                  key=key,
                  shift=bool(mods & 1),
                  alt=bool(mods & 2),
                  ctrl=bool(mods & 4),
                  super=bool(mods & 8),
                  hyper=bool(mods & 16),
                  meta=bool(mods & 32),
              ).as_window_system_event()

              return window.encoded_key(event)


          def split_window(boss, direction):
              if direction == "up" or direction == "down":
                  boss.launch("--cwd=current", "--location=hsplit")
              else:
                  boss.launch("--cwd=current", "--location=vsplit")

              if direction == "up" or direction == "left":
                  boss.active_tab.move_window(direction)


          @result_handler(no_ui=True)
          def handle_result(args, result, target_window_id, boss):
              window = boss.window_id_map.get(target_window_id)

              if window is None:
                  return

              direction = args[1]
              cmd = window.child.foreground_cmdline[0]
              if cmd == "tmux":
                  keymap = args[2]
                  encoded = encode_key_mapping(window, keymap)
                  window.write_to_child(encoded)
              else:
                  split_window(boss, direction)
        '';
    };
  };
}
