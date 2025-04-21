{ ... }:

{

  home.sessionVariables.STARSHIP_LOG = "error";

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 1000;

      character = {
        success_symbol = " [-](bold green) ";
        error_symbol = " [-](bold red) ";
      };

      directory = {
        format = " [$path]($style)[$read_only]($read_only_style) ";
        home_symbol = "⌂";
      };

      cmd_duration = {
        min_time = 500;
        format = " [⧗$duration]($style) ";
        style = "dimmed 8";
      };
    };
  };

}

