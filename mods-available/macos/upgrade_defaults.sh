# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a

# allow sudo without password
# TODO this command works pasted but not from script, still need to debug
# plus it's not wise to not use visudo anyway...
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
#sudo dscl . append /Groups/wheel GroupMembership $(whoami)

# Mountain Lion deletes the file /etc/crontab which is needed for crontab to run.
# If you plan to use scheduled job with cron, you need to type the following command to enable it:
[[ -f /etc/crontab ]] || sudo touch /etc/crontab

# TODO: abstract this
if [[ -d /Volumes/Striped ]]; then
  scutil --set HostName "CharlieDesktop"
else
  scutil --set HostName "CharlieLaptop"
fi

# Delete Apple Crap
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/iTunes.app
loginitems -d 'iTunesHelper'

# https://mercier.link/blog/posts/preventdsstore.php
# http://www.aorensoftware.com/Downloads/Files/DeathToDSStore.zip

# Disable gatekeeper, but don't have a specific need for this that i know of
# sudo spctl --master-disable

# Clear dock
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Japanese keyboard settings
defaults write com.apple.inputmethod.Kotoeri.plist JIMPrefCapsLockActionKey 2
defaults write com.apple.inputmethod.Kotoeri.plist JIMPrefCharacterForSlashKey 0
defaults write com.apple.inputmethod.Kotoeri.plist JIMPrefRomajiKeyboardLayoutKey "com.apple.keylayout.US"
defaults write com.apple.inputmethod.Kotoeri.plist JIMPrefTypingMethodKey 0
defaults write com.apple.inputmethod.Kotoeri.plist JIMPrefVersionKey 1

# Keyboards
defaults write com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID "com.apple.keylayout.US"
defaults write com.apple.HIToolbox.plist AppleEnabledInputSources -array \
  '{InputSourceKind = "Keyboard Layout";"KeyboardLayout ID" = 0;"KeyboardLayout Name" = "U.S.";}' \
  '{InputSourceKind = "Keyboard Layout";"KeyboardLayout ID" = 16301;"KeyboardLayout Name" = "DVORAK - QWERTY CMD";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Japanese";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Roman";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Japanese.Katakana";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";InputSourceKind = "Keyboard Input Method";}'

# Desktop view settings
# TODO defaults read com.apple.finder.plist DesktopViewSettings
