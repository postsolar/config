{ pkgs, ... }:

let

  ghget = pkgs.writeTextFile {
    executable = true;
    destination = "/bin/ghget";
    allowSubstitutes = true;
    preferLocalBuild = false;
    name = "ghget";
    text = builtins.readFile (pkgs.fetchurl {
      url = "https://github.com/mohd-akram/ghget/raw/7f56fd2f5a902a6c8330a8b64da3945e326ef103/ghget";
      hash = "sha256-jwOLBcBz04jCKKYseB0MiRukENd50kq8GXHH6t7EG6A=";
    });
  };

in
{

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userEmail = "120750161+postsolar@users.noreply.github.com";
    userName = "postsolar";

    difftastic.enable = true;
    difftastic.display = "side-by-side";
  };

  home.packages = [
    pkgs.difftastic
    ghget
  ];

}

