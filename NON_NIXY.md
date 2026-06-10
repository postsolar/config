# Non-Nix System Notes

This document lists important but non-reproducible system setup performed.

## Carpalx Keyboard Layout

Why not nixify it?
- home-manager: home.file creates symlinks, symlinks don't work, need a real file
- nix-darwin: system.activationScripts doesn't seem to work (just doesn't get included in system derivation's `activate` script) and i couldnt find another way to create a file in `/`

```sh
git clone https://github.com/JuneKelly/carpalx-macos
sudo cp -rv carpalx-macos/Carpalx.bundle /Library/Keyboard\ Layouts/
```

Then reboot and enable it in System Settings → Keyboard → Input Sources.

**Limitation**: out of the box, cannot have it be the only Latin layout, another one would need to be added alongside. See `help/flush-layouts.sh` for resolution instructions.

## Chrome flags

Why not nixify it? Not managing browsers with Nix for now.

#auto-picture-in-picture-for-video-playback -> false (good in theory, but inconsistent, only works on tab switch but not window switch, easier to just disable it)

## CopyQ quarantine and codesign

Why not nixify it? Homebrew installs the app, but macOS still blocks it until the quarantine attribute is cleared and the app is ad-hoc signed.

```sh
xattr -d com.apple.quarantine /Applications/CopyQ.app
codesign --force --deep --sign - /Applications/CopyQ.app
```

## oMLX menubar app

Why not nixify it? The Homebrew formula is CLI/server-only. It does not install the macOS menubar app, and the maintainer treats Homebrew and DMG as separate distribution channels.

If all you want is the server/CLI, keep using the nix-managed Homebrew formula.

If you want the menubar app, install the `.dmg` from the releases page:

```sh
open https://github.com/jundot/omlx/releases
```

Notes:
- the DMG build includes the actual menubar app in `/Applications`
- it also has built-in auto-update, so this is intentionally non-reproducible / non-Nixy
- don't expect the Homebrew install to create a Dock/menu bar app
