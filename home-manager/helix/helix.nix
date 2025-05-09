{ inputs, system, ... }:

let
  package = inputs.helix-ext.packages.${system}.helix;
in

{
  imports = [
    ./languages.nix
  ];

  programs.helix = {
    enable = true;
    inherit package;

    defaultEditor = true;

    # todo: denixify

    settings = {
      keys.normal = {
        esc = "insert_mode";

        A-S-x = "select_line_above";
        A-x   = "select_line_below";
        S-x   = "extend_line_above";

        tab   = "goto_next_buffer";
        S-tab = "goto_previous_buffer";

        c = [ "trim_selections" "change_selection" ];

        A-o   = "add_newline_below";
        A-S-o = "add_newline_above";

        ret = "goto_word";

        A-t   = [ ":vsplit /tmp/lsp-ai-chat.md" "goto_file_end" "insert_mode" ];
        A-S-t = [ ":sh handlr launch x-scheme-handler/terminal -- hx /tmp/lsp-ai-chat.md" ];

        A-y = "yank_joined";

        g = {
          s = "goto_file_start";
          g = "goto_first_nonwhitespace";
        };

        space = {
          "A-r" = "replace_selections_with_primary_clipboard";
          "A-f" = ":open %sh{ dirname \"%{buffer_name}\" }";
          "A-y" = "yank_to_primary_clipboard";
        };

        A-space = {
          t = ":edit %sh{ mktemp --tmpdir hx.XXXX }";
        };

      };

      theme = "carbonfox";

      editor = {
        cursorline = true;
        gutters = [ "diagnostics" "diff" ];
        scrolloff = 3;
        bufferline = "always";
        color-modes = true;
        jump-label-alphabet = "qaxwrcfsdptvbgjmklnhueyio";
        preview-completion-insert = false;

        auto-pairs = {};

        statusline = {
          left = [ "mode" "spinner" "version-control" ];
          center = [ "file-name" ];
          right = [ "file-modification-indicator" "read-only-indicator" "diagnostics" "selections" "register" "position" "separator" "total-line-numbers" ];
          separator = "/";
          mode.normal = "n";
          mode.insert = "i";
          mode.select = "s";
        };

        lsp = {
          auto-signature-help = false;
        };
      };
    };
  };
}

