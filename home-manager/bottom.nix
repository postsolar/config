{ pkgs, ... }:

{

  programs.bottom = {
    enable = true;
    package = pkgs.bottom;
    settings.flags = {
      default_widget_type        = "proc";
      disable_click              = true;
      expanded_on_startup        = true;
      hide_table_gap             = true;
      left_legend                = true;
      regex                      = true;
      mem_as_value               = true;
      show_table_scroll_position = true;
    };
  };

}

