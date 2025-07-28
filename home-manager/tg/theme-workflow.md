TG works with archived themes, instead of plain (uncompressed) config files.
This adds quite a bit of friction when working with a theme.

**To modify a theme**:
1. Archive the theme:
> ouch c -f zip ./colors.tdesktop-theme phocus.tdesktop-theme
2. Import the theme
3. Edit it using the search in the UI + hyprpicker to match UI elements to variables
4. Export the theme again to save changes (or update the variables here manually)
