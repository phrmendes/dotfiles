{
  lib,
  config,
  ...
}:
{
  options.copyq.enable = lib.mkEnableOption "enable copyq";

  config = lib.mkIf config.copyq.enable {
    services.copyq.enable = true;

    home.file.".config/copyq/themes/gruvbox.ini".text =
      let
        colors = config.lib.stylix.colors.withHashtag;
        fonts = config.stylix.fonts;
      in
      ''
        [General]
        alt_bg=${colors.base01}
        alt_item_css=
        bg=${colors.base00}
        css=
        css_template_items=items
        css_template_main_window=main_window
        css_template_notification=notification
        css_template_tooltip=tooltip
        cur_item_css="\n    ;border: 0.1em solid ${colors.base0D}"
        edit_bg=${colors.base00}
        edit_fg=${colors.base0C}
        edit_font="${fonts.monospace.name},9,-1,5,50,0,0,0,0,0"
        fg=${colors.base05}
        find_bg="rgba(40,40,40,100)"
        find_fg=${colors.base0A}
        find_font="${fonts.sansSerif.name},9,-1,5,50,0,0,0,0,0,Regular"
        font="${fonts.sansSerif.name},9,-1,5,50,0,0,0,0,0,Regular"
        font_antialiasing=true
        hover_item_css=
        icon_size=20
        item_css=
        item_spacing=
        menu_bar_css="\n    ;background: ${colors.base00}\n    ;color: ${colors.base05}"
        menu_bar_disabled_css="\n    ;color: ${colors.base03}"
        menu_bar_selected_css="\n    ;background: ${colors.base0D}\n    ;color: ${colors.base00}"
        menu_css="\n    ;border: 1px solid ${colors.base0D}\n    ;background: ${colors.base00}\n    ;color: ${colors.base05}"
        notes_bg=${colors.base01}
        notes_css=
        notes_fg=${colors.base0E}
        notes_font="${fonts.serif.name},10,-1,5,50,0,0,0,0,0"
        notification_bg=${colors.base01}
        notification_fg=${colors.base05}
        notification_font=
        num_fg=${colors.base0C}
        num_font="${fonts.monospace.name},7,-1,5,25,0,0,0,0,0"
        search_bar="\n    ;background: ${colors.base00}\n    ;color: ${colors.base05}\n    ;border: 1px solid ${colors.base01}\n    ;margin: 2px"
        search_bar_focused="\n    ;border: 1px solid ${colors.base0D}"
        sel_bg=${colors.base02}
        sel_fg=${colors.base05}
        sel_item_css=
        show_number=true
        show_scrollbars=true
        style_main_window=true
        tab_bar_css="\n    ;background: ${colors.base01}"
        tab_bar_item_counter="\n    ;color: ${colors.base04}\n    ;font-size: 6pt"
        tab_bar_scroll_buttons_css="\n    ;background: ${colors.base01}\n    ;color: ${colors.base05}\n    ;border: 0"
        tab_bar_sel_item_counter="\n    ;color: ${colors.base0D}"
        tab_bar_tab_selected_css="\n    ;padding: 0.5em\n    ;background: ${colors.base00}\n    ;border: 0.05em solid ${colors.base00}\n    ;color: ${colors.base05}"
        tab_bar_tab_unselected_css="\n    ;border: 0.05em solid ${colors.base00}\n    ;padding: 0.5em\n    ;background: ${colors.base01}\n    ;color: ${colors.base04}"
        tab_tree_css="\n    ;color: ${colors.base05}\n    ;background-color: ${colors.base00}"
        tab_tree_item_counter="\n    ;color: ${colors.base04}\n    ;font-size: 6pt"
        tab_tree_sel_item_counter="\n    ;color: ${colors.base0D}"
        tab_tree_sel_item_css="\n    ;color: ${colors.base05}\n    ;background-color: ${colors.base02}\n    ;border-radius: 2px"
        tool_bar_css="\n    ;color: ${colors.base05}\n    ;background-color: ${colors.base00}\n    ;border: 0"
        tool_button_css="\n    ;color: ${colors.base05}\n    ;background: ${colors.base00}\n    ;border: 0\n    ;border-radius: 2px"
        tool_button_pressed_css="\n    ;background: ${colors.base02}"
        tool_button_selected_css="\n    ;background: ${colors.base01}\n    ;color: ${colors.base05}\n    ;border: 1px solid ${colors.base0D}"
        use_system_icons=true
      '';
  };
}
