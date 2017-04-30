# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a

# This does not survive reboot. Need 'UseKeychain yes' in ~/.ssh/config
# load identities from keychain
# ssh-add -A

# turn on keychain
keychain

# allow sudo without password
# TODO this command works pasted but not from script, still need to debug
# plus it's not wise to not use visudo anyway...
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
#sudo dscl . append /Groups/wheel GroupMembership $(whoami)

# Mountain Lion deletes the file /etc/crontab which is needed for crontab to run.
# If you plan to use scheduled job with cron, you need to type the following command to enable it:
[[ -f /etc/crontab ]] || sudo touch /etc/crontab

# Increase default disk spindown from 10 mins
sudo pmset -a disksleep 100

# Default applications for filetypes
duti -s org.videolan.vlc .mov all
duti -s org.videolan.vlc .mp4 all
duti -s org.videolan.vlc .mkv all
duti -s com.sublimetext.3 .txt all
duti -s com.sublimetext.3 .py all
duti -s com.sublimetext.3 .php all
duti -s com.sublimetext.3 .sh all
duti -s com.sublimetext.3 .bash all
duti -s com.uranusjr.macdown .md all
duti -s com.uranusjr.macdown .markdown all

# Don't warn "You are opening the application “VLC” for the first time. Are you sure you want to open this application?"
defaults write com.apple.LaunchServices LSQuarantine -bool NO

# TODO: abstract this
if [[ -d /Volumes/Striped ]]; then
  scutil --set HostName "CharlieDesktop"
  scutil --set LocalHostName "CharlieDesktop"
  scutil --set ComputerName "CharlieDesktop"
else
  scutil --set HostName "CharlieLaptop"
  scutil --set LocalHostName "CharlieLaptop"
  scutil --set ComputerName "CharlieLaptop"
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
defaults write com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID "com.apple.keylayout.Dvorak"
defaults write com.apple.HIToolbox.plist AppleEnabledInputSources -array \
  '{InputSourceKind = "Keyboard Layout";"KeyboardLayout ID" = 0;"KeyboardLayout Name" = "U.S.";}' \
  '{InputSourceKind = "Keyboard Layout";"KeyboardLayout ID" = 16300;"KeyboardLayout Name" = "Dvorak";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Japanese";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Roman";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";"Input Mode" = "com.apple.inputmethod.Japanese.Katakana";InputSourceKind = "Input Mode";}' \
  '{"Bundle ID" = "com.apple.inputmethod.Kotoeri";InputSourceKind = "Keyboard Input Method";}' \
  '{"Bundle ID" = "com.apple.50onPaletteIM";InputSourceKind = "Non Keyboard Input Method";}'

# Enable shortcut keys to switch input types, haven't confirmed 60 and 61 never change
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:61:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Stop console spam:
# (com.apple.wifivelocityd): Service only ran for 0 seconds. Pushing respawn out by 10 seconds.
# http://www.insanelymac.com/forum/topic/317694-wifi-wifivelocityd-spamming-system-log/
sudo defaults write /System/Library/LaunchDaemons/com.apple.wifivelocityd.plist Disabled -bool YES

# Enable screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
# Enable file sharing
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk
# Enable remote login
sudo systemsetup -f -setremotelogin on

# Desktop view settings
# TODO defaults read com.apple.finder.plist DesktopViewSettings
