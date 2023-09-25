{
  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
        open_help: Some(( code: F(1), modifiers: ( bits: 0,),)),
        move_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
        move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
        move_up: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
        move_down: Some(( code: Char('j'), modifiers: ( bits: 0,),)),
        popup_up: Some(( code: Char('p'), modifiers: ( bits: 2,),)),
        popup_down: Some(( code: Char('n'), modifiers: ( bits: 2,),)),
        page_up: Some(( code: Char('b'), modifiers: ( bits: 2,),)),
        page_down: Some(( code: Char('f'), modifiers: ( bits: 2,),)),
        home: Some(( code: Char('g'), modifiers: ( bits: 0,),)),
        end: Some(( code: Char('G'), modifiers: ( bits: 1,),)),
        shift_up: Some(( code: Char('K'), modifiers: ( bits: 1,),)),
        shift_down: Some(( code: Char('J'), modifiers: ( bits: 1,),)),
        edit_file: Some(( code: Char('I'), modifiers: ( bits: 1,),)),
        status_reset_item: Some(( code: Char('U'), modifiers: ( bits: 1,),)),
        diff_reset_lines: Some(( code: Char('u'), modifiers: ( bits: 0,),)),
        diff_stage_lines: Some(( code: Char('s'), modifiers: ( bits: 0,),)),
        stashing_save: Some(( code: Char('w'), modifiers: ( bits: 0,),)),
        stashing_toggle_index: Some(( code: Char('m'), modifiers: ( bits: 0,),)),
        stash_open: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
        abort_merge: Some(( code: Char('M'), modifiers: ( bits: 1,),)),
      )
    '';
    theme = ''
      (
        selected_tab: Reset,
        command_fg: Rgb(205, 214, 244),
        selection_bg: Rgb(88, 91, 112),
        selection_fg: Rgb(205, 214, 244),
        cmdbar_bg: Rgb(24, 24, 37),
        cmdbar_extra_lines_bg: Rgb(24, 24, 37),
        disabled_fg: Rgb(127, 132, 156),
        diff_line_add: Rgb(166, 227, 161),
        diff_line_delete: Rgb(243, 139, 168),
        diff_file_added: Rgb(249, 226, 175),
        diff_file_removed: Rgb(235, 160, 172),
        diff_file_moved: Rgb(203, 166, 247),
        diff_file_modified: Rgb(250, 179, 135),
        commit_hash: Rgb(180, 190, 254),
        commit_time: Rgb(186, 194, 222),
        commit_author: Rgb(116, 199, 236),
        danger_fg: Rgb(243, 139, 168),
        push_gauge_bg: Rgb(137, 180, 250),
        push_gauge_fg: Rgb(30, 30, 46),
        tag_fg: Rgb(245, 224, 220),
        branch_fg: Rgb(148, 226, 213)
      )
    '';
  };
}
