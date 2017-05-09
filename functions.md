# Standalone functions and scripts

These are in varying stages of development, but they might at least have useful
bits.

**[schedule-task](mods-available/base/functions/schedule-task)**

Add a cron job if it doesn't exist.

* Usage: `schedule-task 'line_as_will_appear_in_crontab' [ user ]`
* Example: `schedule-task '*/3 * * * *  cd /usr/lib/cgi-bin/mt; perl ./tools/run-periodic-tasks -verbose >> /var/log/rpt.log 2>&1' www-data`

**[sync-defaults-simple](mods-available/base/functions/sync-defaults-simple)**

Previously I had lists of commands like `defaults write com.apple...` for setting up my system.
I had to manually update those commands whenever I changed something I wanted to be permanent.

I wanted to convert that system to one where the settings are stored in a file and the file could either be applied to the system or updated from the system.
It seemed logical to have the file format be the same as that used by `defaults read` so I could do `defaults read com.apple... > file` and then modify the file to contain my desired settings.

This script was the start of that, though I realized it would be difficult or impossible to have `defaults write` deal with arrays and dictionaries.
I may forgo this solution in favor of using XML based plist files that PlistBuddy could edit.
I think I still should use `defaults` to apply settings since OSX has an app notification framework I would skip if I modified `~/Library/Preferences` directly.

**[update-defaults-files](mods-available/base/functions/update-defaults-files)**

Run [sync-defaults-simple](mods-available/base/functions/sync-defaults-simple) for each plist within `defaults` directories within all enabled modules.

**[sync-private-data](mods-available/base/functions/sync-private-data)**

This function is to allow for scheduled updating of the private files managed in a private repository assumed to be in a folder called `private` inside the dotfiles folder.

`zsh_history` stores additions to the shell history file in the private repo.
It also merges the histories of all managed computers and puts that on the local computer so it can be used for back searching.
The function also automatically commits and pushes changes to the remote.

**[transmission_incremental_load](mods-available/productivity_extra/functions/transmission_incremental_load)**

The Transmission bittorrent client on macOS can freeze upon adding too many torrents to the watched directory.
The program must then be forcefully terminated, which causes data loss at best.
At worst, it causes inability to reopen the program without completely clearing the torrent list and starting over.
This circular situation arises when initially migrating to Transmission from another client or when migrating to a new system.

`transmission_incremental_load` automates moving small batches of torrent files into the directory watched by Transmission and then waiting the estimated time required for Transmission to check existing data based on the cumulative size of the corresponding already downloaded files.

It also provides rudimentary backup and restore of Transmission application state to hopefully allow for recovery in the event a hang cycle still occurs.
State is automatically backed up before each batch move. State can be recovered with the restore subcommand.

