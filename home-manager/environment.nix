{ pkgs, ... }:

{

  home.sessionVariables = {

    NIXPKGS_ALLOW_UNFREE = 1;

    __HM_SESS_VARS_SOURCED = "";

    EDITOR = "hx";

    BROWSER = "firefox-developer-edition";

    MANROFFOPT = "-c";

    MANPAGER = pkgs.writeShellScript "kak-pager" ''
      # get the page name, discard the input, and open the page again 
      # via kakoune's man command because it has auto-reflowing
      head -n 1 | col -b | kak -e '
        hook -once global NormalIdle .* %{
          exec -with-hooks %{<a-e>`y:db<ret>:man <c-r>"<ret>}
        }
        '
      '';

    PAGER = "kak";

    FX_THEME = 1;

  };

}

