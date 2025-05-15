{ inputs, system, pkgs, ... }:

let
  package = inputs.helix-ext.packages.${system}.helix;
in

{
  programs.helix = {
    enable = true;
    inherit package;
    defaultEditor = true;
  };

  xdg.configFile = {
    "helix/config.toml".text = # toml
      ''
      theme = "carbonfox"

      [editor]
      bufferline = "always"
      color-modes = true
      cursorline = true
      gutters = ["diagnostics", "diff"]
      jump-label-alphabet = "qwfarsxcd"
      preview-completion-insert = false
      scrolloff = 3

      [editor.auto-pairs]

      [editor.lsp]
      auto-signature-help = false

      [editor.statusline]
      center = ["file-name"]
      left = ["mode", "spinner", "version-control"]
      right = [
          "file-modification-indicator",
          "read-only-indicator",
          "diagnostics",
          "selections",
          "register",
          "position",
          "separator",
          "total-line-numbers",
      ]
      separator = "/"

      [editor.statusline.mode]
      insert = "i"
      normal = "n"
      select = "s"

      [keys.normal]
      A-S-o = "add_newline_above"
      A-S-t = [":sh handlr launch x-scheme-handler/terminal -- hx /tmp/lsp-ai-chat.md"]
      A-S-x = "select_line_above"
      A-o = "add_newline_below"
      A-t = [":vsplit /tmp/lsp-ai-chat.md", "goto_file_end", "insert_mode"]
      A-x = "select_line_below"
      A-y = "yank_joined"
      S-tab = "goto_previous_buffer"
      S-x = "extend_line_above"
      c = ["trim_selections", "change_selection"]
      esc = "insert_mode"
      ret = "goto_word"
      tab = "goto_next_buffer"

      [keys.normal.g]
      g = "goto_first_nonwhitespace"
      s = "goto_file_start"

      [keys.normal.space]
      A-f = ":open %sh{ dirname \"%{buffer_name}\" }"
      A-r = "replace_selections_with_primary_clipboard"
      A-y = "yank_to_primary_clipboard"

      [keys.normal.A-space]
      t = ":edit %sh{ mktemp --tmpdir hx.XXXX }"
      '';

    "helix/languages.toml".text = # toml
      ''
      # ~ lsps

      [language-server.lsp-ai]
      command = "lsp-ai"
      # don't worry about the typo: https://github.com/SilasMarvin/lsp-ai/blob/1e910a8cf0048406eb227bf2064743010a9ff3a9/crates/lsp-ai/src/main.rs#L89
      # the file is ~/.cache/lsp-ai/lsp-ai.log , only written to with LSP_AI_LOG=DEBUG
      args = ["--config", "${ import ./lsp-ai-config.nix |> builtins.toJSON |> pkgs.writeText "lsp-ai config.json" }", "--use-seperate-log-file"]

      # ~ languages

      [[language]]
      name = "fish"
      auto-format = false

      [[language]]
      name = "hyprlang"
      # https://github.com/hyprwm/hyprlang/issues/13#issuecomment-1984930603
      # + i don't even know of any other formats using .hl (though i'm sure they do exist)
      file-types = [ { glob = "hypr/*.conf" }, { glob = "*.hl" } ]

      [[language]]
      name = "typescript"
      language-servers = ["typescript-language-server", "lsp-ai"]

      [[language]]
      name = "markdown"
      language-servers = ["marksman", "lsp-ai"]

      [[language]]
      name = "nim"
      language-servers = ["nimlsp", "nimlangserver"]
      '';
  };
}

