# Standalone functions and scripts

These are in varying stages of development, but they might at least have useful
bits.

**[sync-defaults-simple](mods-available/base/functions/sync-defaults-simple)**

Previously I had lists of commands like `defaults write com.apple...` for setting up my system.
I had to manually update those commands whenever I changed something I wanted to be permanent.

I wanted to convert that system to one where the settings are stored in a file and the file could either be applied to the system or updated from the system.
It seemed logical to have the file format be the same as that used by `defaults read` so I could do `defaults read com.apple... > file` and then modify the file to contain my desired settings.

This script was the start of that, though I realized it would be difficult or impossible to have `defaults write` deal with arrays and dictionaries.
I may forgo this solution in favor of using XML based plist files that PlistBuddy could edit.
I think I still should use `defaults` to apply settings since OSX has an app notification framework I would skip if I modified `~/Library/Preferences` directly.
