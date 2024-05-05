{ pkgs, ... }:

let

  toToml = (pkgs.formats.toml {}).generate;

  aliases = {
    openRgFzf = ":open %sh{ foot-floating --center-active --active-ratios 70 70 -- rg+fzf -l : | xargs printf '%s ' }";
    openFzfLinewise = {
      global = ":open %sh{ foot-floating --center-active --active-ratios 70 70 -- fzf-linewise } ";
      currentFile = ":open %sh{ foot-floating --center-active --active-ratios 70 70 -- fzf-linewise -f %{filename} } ";
    };
  };

  functions = {
    extending = action: [ "select_mode" action "normal_mode" ];
  };

  keys = rec {
    normal = rec {

      # essentials
      ":" = "command_mode";
      "ret" = "goto_word";
      "S-ret" = functions.extending "extend_to_word";

      # shell stuff
      # curiously this doesn't cover everything,
      # "$" = ":sh ydotool key 58:1 && ydotool type \":SH \" -D 1 -H 1 -d 1 && ydotool key 58:0";
      "|"    = "shell_pipe";
      "A-|"  = "shell_keep_pipe";
      "A-\\" = "shell_pipe_to";
      "!"    = "shell_insert_output";
      "A-!"  = "shell_append_output";
      C-z    = "suspend";

      # splits
      v = {
        left    = "jump_view_left";
        down    = "jump_view_down";
        up      = "jump_view_up";
        right   = "jump_view_right";

        S-left  = "swap_view_left";
        S-down  = "swap_view_down";
        S-up    = "swap_view_up";
        S-right = "swap_view_right";

        S-s     = "transpose_view";

        v       = "align_view_center";
        m       = "align_view_middle";
        t       = "align_view_top";
        b       = "align_view_bottom";

        o       = "wonly";
        c       = "wclose";
        q       = ":quit";
        S-q     = ":quit-all";

        f       = "goto_file_vsplit";
        S-f     = "goto_file_hsplit";
      };

      # buffers
      tab   = ":buffer-next";
      S-tab = ":buffer-previous";
      A-tab = "buffer_picker";

      # macros
      "^" = "record_macro";
      "A-^" = "replay_macro";

      # trivial modifications
      "="     = ":format";
      "#"     = "toggle_line_comments";
      "A-#"   = "toggle_block_comments";
      "A-b"   = "indent";
      "A-S-b" = "unindent";
      "`"     = "switch_to_lowercase";
      "~"     = "switch_to_uppercase";
      "A-`"   = "switch_case";
      "'"     = "select_register";

      "A-a"   = "increment";
      "A-S-a" = "decrement";

      # changes
      u = "undo";
      U = "redo";

      # insert mode portals
      i     = "insert_mode";
      S-i   = "insert_at_line_start";
      a     = "append_mode";
      S-a   = "insert_at_line_end";
      # A-a   = [ "collapse_selection" "append_mode" ];
      c     = [ "trim_selections" "change_selection" ];
      A-c   = [ "trim_selections" "change_selection_noyank" ];
      o     = [ "collapse_selection" "open_below" ];
      S-o   = [ "collapse_selection" "open_above" ];
      A-o   = "add_newline_below";
      A-S-o = "add_newline_above";
      # d goes here too because where else
      d     = "delete_selection";
      A-d   = "delete_selection_noyank";

      # basic navigation
      q       = "move_prev_word_start";
      w       = "move_next_word_start";
      f       = "move_next_word_end";
      S-q     = "extend_prev_word_start";
      S-w     = "extend_next_word_start";
      S-f     = "extend_next_word_end";
      A-q     = "move_prev_long_word_start";
      A-w     = "move_next_long_word_start";
      A-f     = "move_next_long_word_end";
      A-S-q   = "extend_prev_long_word_start";
      A-S-w   = "extend_next_long_word_start";
      A-S-f   = "extend_next_long_word_end";

      left    = "move_char_left";
      down    = "move_line_down";
      right   = "move_char_right";
      up      = "move_line_up";
      S-left  = "extend_char_left";
      S-down  = "extend_line_down";
      S-right = "extend_char_right";
      S-up    = "extend_line_up";
      home    = "goto_first_nonwhitespace";
      end     = "goto_line_end_newline";

      # less basic navigation

      # this one is useless because what a "motion" is is very limited
      # "A-."   = "repeat_last_motion";
      # doesn't work for some reason
      # "A-S-." = functions.extending "repeat_last_motion";

      # too convenient to leave this key for paste,
      # also happens to be right next to q/w/f on colemak
      p       = "goto_next_paragraph";
      A-p     = "goto_prev_paragraph";
      S-p     = functions.extending p;
      A-S-p   = functions.extending A-p;

      t       = "find_till_char";
      S-t     = "extend_till_char";
      A-t     = "till_prev_char";
      A-S-t   = "extend_till_prev_char";
      e       = "find_next_char";
      S-e     = "extend_next_char";
      A-e     = "find_prev_char";
      A-S-e   = "extend_prev_char";

      lt      = "jump_forward";
      gt      = "jump_backward";
      l       = "save_selection";

      # goto
      g = {
        # intra-buffer movement
        g     = "goto_first_nonwhitespace";
        s     = "goto_file_start";
        "#"   = "goto_line";
        e     = "goto_file_end";
        S-e   = "goto_last_line";
        t     = "goto_window_top";
        c     = "goto_window_center";
        b     = "goto_window_bottom";
        left  = "goto_line_start";
        right = "goto_line_end_newline";
        "."   = "goto_last_modification";
        # lsp
        r     = "goto_reference";
        d     = "goto_definition";
        # files
        f     = "goto_file";
        a     = "goto_last_accessed_file";
        m     = "goto_last_modified_file";
        h     = "goto_file_hsplit";
        v     = "goto_file_vsplit";
        w     = "goto_word";
      };
      S-g = with functions; {
        g     = "extend_to_first_nonwhitespace";
        s     = extending g.s;
        "#"   = extending g."#";
        e     = extending g.e;
        S-e   = extending g.S-e;
        t     = extending g.t;
        c     = extending g.c;
        b     = extending g.b;
        left  = "extend_to_line_start";
        right = "extend_to_line_end";
        "."   = extending g.".";
      };

      # selection manipulation
      x       = "extend_line_below";
      S-x     = "extend_line_above";
      A-x     = "shrink_to_line_bounds";
      S-c     = "copy_selection_on_next_line";
      A-S-c   = "copy_selection_on_prev_line";
      "%"     = "select_all";
      "&"     = "align_selections";

      "_"     = "trim_selections";
      ";"     = "collapse_selection";
      "A-:"   = "flip_selections";
      "A-;"   = "ensure_selections_forward";
      ","     = "keep_primary_selection";
      "A-,"   = "remove_primary_selection";
      "("     = "rotate_selections_backward";
      ")"     = "rotate_selections_forward";
      "A-("   = "rotate_selection_contents_backward";
      "A-)"   = "rotate_selection_contents_forward";
      "A-="   = "reverse_selection_contents";

      s       = "select_regex";
      S-s     = "split_selection";
      A-s     = "split_selection_on_newline";
      A-j     = "join_selections";
      A-S-j   = "join_selections_space";
      A-k     = "keep_selections";
      A-S-k   = "remove_selections";
      A-minus = "merge_selections";
      A-_     = "merge_consecutive_selections";

      # search
      "/"   = "search";
      "?"   = "rsearch";
      n     = "search_next";
      A-n   = "search_prev";
      S-n   = "extend_search_next";
      A-S-n = "extend_search_prev";
      # I wish there was an extra mod key for this
      # ??? = [ S-n "merge_selections" ];
      # ??? = [ A-S-n "merge_selections" ];
      "*"   = [ "search_selection" "make_search_word_bounded" ];
      "A-*" = [ "search_selection" ];

      # yank / paste / replace
      y   = "yank";
      A-y = "yank_joined";
      z   = "paste_after";
      S-z = "paste_before";
      r   = "replace";
      S-r = "replace_with_yanked";

      # tree-sitter and bidirectional text objects stuff
      A-up      = "expand_selection";
      A-down    = "shrink_selection";
      A-left    = "select_prev_sibling";
      A-right   = "select_next_sibling";

      # don't work :(
      A-S-left  = functions.extending A-left;
      A-S-right = functions.extending A-right;

      A-S-up    = "select_all_siblings";
      A-S-down  = "select_all_children";

      "A-["     = "move_parent_node_start";
      "A-]"     = "move_parent_node_end";
      "A-{"     = "extend_parent_node_start";
      "A-}"     = "extend_parent_node_end";

      "[" = {
        d   = "goto_prev_diag";
        S-d = "goto_first_diag";
        f   = "goto_prev_function";
        t   = "goto_prev_class";
        c   = "goto_prev_comment";
        g   = "goto_prev_change";
        S-g = "goto_first_change";
      };

      "{" = with functions; {
        d   = extending normal."[".d;
        S-d = extending normal."[".S-d;
        f   = extending normal."[".f;
        t   = extending normal."[".t;
        c   = extending normal."[".c;
        g   = extending normal."[".g;
        S-g = extending normal."[".S-g;
      };

      "]" = {
        d   = "goto_next_diag";
        S-d = "goto_last_diag";
        f   = "goto_next_function";
        t   = "goto_next_class";
        c   = "goto_next_comment";
        g   = "goto_next_change";
        S-g = "goto_last_change";
      };

      "}" = with functions; {
        d   = extending normal."]".d;
        S-d = extending normal."]".S-d;
        f   = extending normal."]".f;
        t   = extending normal."]".t;
        c   = extending normal."]".c;
        g   = extending normal."]".g;
        S-g = extending normal."]".S-g;
      };

      # surround
      m = {
        m = "match_brackets";
        s = "surround_add";
        r = "surround_replace";
        d = "surround_delete";
        a = "select_textobject_around";
        i = "select_textobject_inner";
      };

      # pickers
      backspace = {
        backspace = "last_picker";
        ":"       = "command_palette";
        f         = "file_picker";
        S-f       = "file_picker_in_current_buffer_directory";
        A-f       = "file_picker_in_current_directory";
        j         = "jumplist_picker";
        b         = "buffer_picker";
        s         = "symbol_picker";
        S-s       = "workspace_symbol_picker";
        d         = "diagnostics_picker";
        S-d       = "workspace_diagnostics_picker";
        c         = ":lsp-workspace-command";
        "/"       = "global_search";
      };

      # other - internal
      space = {
        space = "hover";
        a     = "code_action";
        s     = "select_references_to_symbol_under_cursor";
        r     = ":reload";
        S-r   = ":reload-all";
      };

      # useful things which didn't end up elsewhere
      A-space = {
        c   = "completion";
        d   = [ "extend_to_line_bounds" "yank" "paste_after" ];
        "*" = [ "select_all" "select_regex" ];
        g   = aliases.openRgFzf;
        l   = aliases.openFzfLinewise.currentFile;
        S-l = aliases.openFzfLinewise.global;
        f   = ":open %sh{ foot-floating --center -- lf -print-selection }";
      };

    };

    insert = {
      esc = "normal_mode";

      left          = "move_char_left";
      down          = "move_visual_line_down";
      up            = "move_visual_line_up";
      right         = "move_char_right";
      S-left        = [ "move_prev_long_word_start" "collapse_selection" ];
      S-right       = [ "move_next_long_word_end" "move_char_right" "collapse_selection" ];
      A-left        = "goto_first_nonwhitespace";
      A-right       = "goto_line_end_newline";
      # A-S-left      = "";
      # A-S-right     = "";

      backspace     = "delete_char_backward";
      S-backspace   = "delete_word_backward";
      A-backspace   = [ "move_char_left" "extend_to_first_nonwhitespace" "change_selection_noyank" ];
      A-S-backspace = [ "goto_first_nonwhitespace" "extend_to_line_end" "change_selection_noyank" ];

      del = "delete_char_forward";
      S-del = "delete_word_forward";
      A-del = "kill_to_line_end";

      ret           = "insert_newline";
      S-ret         = "open_above";
      A-ret         = "add_newline_below";
      A-S-ret       = "add_newline_above";

      tab = "indent";
      S-tab = "unindent";

      A-space = "signature_help";

      C-r = "insert_register";

      A-w = ":write";

    };
  };
in
  toToml "helix-keybindings" { inherit keys; }
