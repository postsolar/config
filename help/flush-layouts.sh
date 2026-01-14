# Remove forced presence of a "🍏blessed🍏" latin layout
#
# Source: https://superuser.com/a/1840361
#
# On command line, a method that works for me on 14.4.1 and has been working for a few major versions already:
#
# Get the XML snippets for the keyboard layouts you want to keep: defaults export com.apple.HIToolbox -, then save the <dict> blocks you need below <array> below <key>AppleEnabledInputSources</key>
#
# Wipe all the layouts: defaults delete com.apple.HIToolbox AppleEnabledInputSources
#
# For each XML snippet corresponding to a custom layout you want to add, edit it to a single line and execute defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add 'your xml'. For example, defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>-4377</integer><key>KeyboardLayout Name</key><string>Lithuanian Standard</string></dict>'
#
# You might or might not do this globally, for that use the same commands prepended with sudo and adding -g before com.apple.HIToolbox. If the export command returns nothings, you don't have global settings, and you don't need to do the rest of it.
#
# Restart
