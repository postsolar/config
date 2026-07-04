# AGENTS.md

This file provides guidance to coding agents when working with this repository.

## Common Commands

See `Justfile` for available helper commands for working with this flake.

IMPORTANT: When running Home Manager rebuilds in non-interactive contexts (if you're an agent, you are always in a non-interactive context), use `just home-agent` instead of `just home`. The `home` command includes `--verbose`, which produces extremely large output in non-interactive mode.

## Codex Sandbox Notes

For Codex: run Nix check/eval/build/rebuild commands with approval escalation up front. These commonly need cache/state access outside `~/nix`, for example `~/.cache/nix`, so asking first avoids a guaranteed sandbox failure and retry.
