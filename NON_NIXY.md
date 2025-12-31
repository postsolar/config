# Non-Nix System Notes

## Auto-Hide Cursor

```sh
brew install --cask cursorcerer
open ~/Library/PreferencePanes/Cursorcerer.prefPane
```

if fails because of certificates:
```fish
HOMEBREW_CURLRC=$(echo insecure | psub) brew install --cask cursorcerer
open ~/Library/PreferencePanes/Cursorcerer.prefPane
```

## Carpalx Keyboard Layout

README claims we can install to user-level location, but I did not find this to work. System-level location only.

```sh
git clone https://github.com/JuneKelly/carpalx-macos
sudo mv carpalx-macos/Carpalx.bundle /Library/Keyboard\ Layouts/
```

Then reboot and enable it in System Settings → Keyboard → Input Sources.

Limitation: cannot have it be the only Latin (?) layout, another one would need to be added alongside. The reason is seemingly the usual security theater. This could possibly be worked around by fucking with stuff in system paths instead.
