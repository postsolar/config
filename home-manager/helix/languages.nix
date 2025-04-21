{ pkgs, ... }:

let

  # ~ lsps

  lsp-ai = {
    command = "lsp-ai";
    args = [
      "--config"
      "${ import ./lsp-ai-config.nix |> builtins.toJSON |> pkgs.writeText "lsp-ai config.json" }"
      # don't worry about the typo: https://github.com/SilasMarvin/lsp-ai/blob/1e910a8cf0048406eb227bf2064743010a9ff3a9/crates/lsp-ai/src/main.rs#L89
      # the file is ~/.cache/lsp-ai/lsp-ai.log , only written to with LSP_AI_LOG=DEBUG
      "--use-seperate-log-file"
    ];
  };

  # ~ languages

  fish = {
    name = "fish";
    auto-format = false;
  };

  hyprlang = {
    name = "hyprlang";
    # https://github.com/hyprwm/hyprlang/issues/13#issuecomment-1984930603
    # + i don't even know of any other formats using .hl (though i'm sure they do exist)
    file-types = [ { glob = "hypr/*.conf"; } { glob = "*.hl"; } ];
  };

  typescript = {
    name = "typescript";
    language-servers = [ "lsp-ai" ];
  };

  markdown = {
    name = "markdown";
    language-servers = [ "lsp-ai" ];
  };

in

{

  programs.helix.languages = {

    language = [
      fish
      hyprlang
      typescript
      markdown
    ];

    language-server = {
      inherit
        lsp-ai
        ;
    };

  };

}
