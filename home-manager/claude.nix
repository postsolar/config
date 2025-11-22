{ lib, pkgs, ... }:

# TODO make it use xdg dirs

# docs are unfortunately quite obscure and not very user-friendly
# https://code.claude.com/docs/en/settings

let
  claudeJson = pkgs.writeText "claude-settings.json" (builtins.toJSON claudeConf);

  claudeConf = {
    permissions.allow = [
      "WebFetch"
      "WebSearch"
    ];

    alwaysThinkingEnabled = true;

    env = {
      # dont do background tasks unprompted, see https://github.com/anthropics/claude-code/issues/5615
      BASH_DEFAULT_TIMEOUT_MS = "86400000";
      BASH_MAX_TIMEOUT_MS = "86400000";
    };
  };
in

{
  home.packages = [ pkgs.claude-code ];

  home.activation.generateClaudeConfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.claude"
      ${lib.getExe pkgs.jq} . ${claudeJson} > "$HOME/.claude/settings.json"
      chmod a+rw "$HOME/.claude/settings.json"
    '';
}
