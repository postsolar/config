# AGENTS.md

This file provides guidance to coding agents when working with this repository.

## Common Commands

See `Justfile` for available helper commands for working with this flake.

IMPORTANT: When running Home Manager rebuilds in non-interactive contexts, use `just home-agent` instead of `just home`. The `home` command includes `--verbose`, which produces extremely large output.
