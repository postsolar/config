# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

See @Justfile for available helper commands for working with Nix flakes and this flake specifically.

**IMPORTANT**: When running system rebuilds, use `just switch-claude` instead of `just switch`. The regular `switch` command includes `--verbose` which causes excessive output (10k+ lines showing every file evaluation) in non-interactive contexts like Claude Code.
