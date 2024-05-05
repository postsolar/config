{ ... }:

{
  programs.fzf = {
    enable = true;
    colors = {
      "fg"         = "-1";            # Text
      "bg"         = "-1";            # Background
      "preview-fg" = "-1";            # Preview window text
      "preview-bg" = "-1";            # Preview window background
      "hl"         = "1";             # Highlighted substrings
      "fg+"        = "-1:reverse";    # Text (current line)
      "bg+"        = "-1";            # Background (current line)
      "gutter"     = "-1";            # Gutter on the left (defaults to bg+)
      "hl+"        = "1";             # Highlighted substrings (current line)
      "info"       = "-1:dim";        # Info
      "border"     = "-1:dim";        # Border of the preview window and horizontal separators (--border)
      "prompt"     = "1";             # Prompt
      "pointer"    = "1";             # Pointer to the current line
      "marker"     = "1";             # Multi-select marker
      "spinner"    = "1";             # Streaming input indicator
      "header"     = "1:italic:bold"; # Header
    };

    # changeDirWidgetCommand = "fd . -td --follow --hidden --color always --print0 --base-directory $CDPATH";
    # changeDirWidgetOptions = [ "--read0" ];

    # fileWidgetCommand      = "fd . --follow --hidden --color always --print0";
    # fileWidgetOptions      = [ "--read0" ];

    # defaultCommand = "fd . -tf --follow --hidden --color always";

    defaultOptions =
      [ "--multi"
        "--cycle"
        "--keep-right"
        "--scroll-off=100"
        "--no-hscroll"
        "--filepath-word"
        "--jump-labels='qwfparstxcdvbgzjmklnhue,yi.;o/[]'"
        "--info=inline-right"
        "--no-separator"
        "--prompt='  '"
        "--pointer=' '"
        "--marker='┃'"
        "--ellipsis='…'"
        "--ansi"
        "--tabstop=4"
        # "--color=hl:5,gutter:-1,info:0,scrollbar:0:dim,preview-border:0,preview-scrollbar:0:dim,preview-label:5:italic,prompt:5:bold,pointer:1:bold,marker:1:bold,spinner:1:bold"
        "--preview-label-pos=-2:bottom"
        "--preview-window=,wrap,border-left,cycle"
        "--bind='alt-left:prev-selected'"
        "--bind='alt-right:next-selected'"
        "--bind='alt-down:first'"
        "--bind='alt-up:last'"
        "--bind='alt-enter:jump'"
        "--bind='alt-/:jump-accept'"
        "--bind='alt-a:select-all'"
        "--bind='alt-A:select-all+accept'"
        "--bind='alt-n:deselect-all'"
        "--bind='alt-v:toggle-all'"
        "--bind='alt-V:toggle-all+accept'"
        "--bind='alt-p:change-preview-window:right,70%|up,60%,border-horizontal|left,80%,border-right|hidden'"
        "--bind='alt-y:execute-silent:printf \"%s\\n\" {+} | wl-copy -p -n'"
        "--bind='alt-Y:execute-silent:printf \"%s\\n\" {+} | wl-copy -n'"
        "--bind='alt-e:execute(hx {+})'"
        "--bind='alt-E:become(hx {+})'"
        "--bind='shift-up:preview-up+preview-up'"
        "--bind='shift-down:preview-down+preview-down'"
        "--bind='preview-scroll-up:preview-up+preview-up'"
        "--bind='preview-scroll-down:preview-down+preview-down'"
      ];
  };

}
