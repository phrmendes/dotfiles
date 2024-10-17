{
  lib,
  config,
  ...
}: {
  options.sioyek.enable = lib.mkEnableOption "enable sioyek";

  config = lib.mkIf config.sioyek.enable {
    programs.sioyek = let
      colors_with_hashtag = config.lib.stylix.colors.withHashtag;
      r = config.lib.stylix.colors.base0A-rgb-r;
      g = config.lib.stylix.colors.base0A-rgb-g;
      b = config.lib.stylix.colors.base0A-rgb-b;
    in {
      enable = true;
      bindings = {
        add_bookmark = "ab";
        add_highlight = "ah";
        chapter_search = "c/";
        close_window = "<space>q";
        copy = "y";
        delete_bookmark = "db";
        delete_highlight = "dh";
        delete_portal = "dp";
        edit_portal = "ep";
        goto_bookmark = "gb";
        goto_bookmark_g = "gB";
        goto_definition = "gd";
        goto_highlight = "gh";
        goto_highlight_g = "gH";
        goto_mark = "gm";
        goto_next_highlight = "]h";
        goto_portal = "gp";
        goto_prev_highlight = "[h";
        goto_toc = "gt";
        move_down = "j";
        move_left = "l";
        move_right = "h";
        move_up = "k";
        move_visual_mark_down = "j";
        move_visual_mark_up = "k";
        new_window = "<space>n";
        next_chapter = "]c";
        next_preview = "]p";
        next_state = "]s";
        open_document = "<space>o";
        open_document_embedded = "<space>O";
        open_link = "ol";
        portal = "ap";
        prev_chapter = "[c";
        prev_state = "[s";
        previous_preview = "[p";
        screen_down = ["<C-d>" ""];
        screen_up = ["<C-u>" ""];
        search = "/";
        set_mark = "am";
        toggle_dark_mode = "td";
        toggle_fullscreen = "tf";
        toggle_highlight = "th";
      };
      config = with colors_with_hashtag; {
        should_load_tutorial_when_no_other_file = "0";
        background_color = base00;
        custom_background_color = base00;
        custom_text_color = base07;
        dark_mode_background_color = base00;
        link_highlight_color = base0C;
        page_separator_color = base00;
        search_highlight_color = base0A;
        status_bar_color = base00;
        status_bar_text_color = base07;
        synctex_highlight_color = base08;
        text_highlight_color = base03;
        ui_background_color = base02;
        ui_selected_background_color = base03;
        ui_selected_text_color = base07;
        ui_text_color = base07;
        visual_mark_color = "${r} ${g} ${b} 0.2";
      };
    };
  };
}
