{ ... }:

{

  xdg.configFile."helix/snippets/nix.json".source =
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/rafamadriz/friendly-snippets/main/snippets/nix.json";
      sha256 = "0k4iaig77rqzk8zxdplwhqq8sjsjbf326mygqvgcplv97sdxhffp";
    };

  xdg.configFile."helix/snippets/purescript.json".source =
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/rafamadriz/friendly-snippets/f3f061b0909bb7e1c62ff5f4e83b835965aac330/snippets/purescript.json";
      sha256 = "082wn844aa58ryq8rs5pgnn4fib3brgclrxqkfsf1d1hhmzcnl05";
    };

}

