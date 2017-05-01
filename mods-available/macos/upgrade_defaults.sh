# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a

# This does not survive reboot. Need 'UseKeychain yes' in ~/.ssh/config
# load identities from keychain
# ssh-add -A

# turn on keychain
keychain

defaults write NSGlobalDomain com.apple.springing.delay -float 1

# allow sudo without password
# TODO this command works pasted but not from script, still need to debug
# plus it's not wise to not use visudo anyway...
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
#sudo dscl . append /Groups/wheel GroupMembership $(whoami)
#
# enable root account
# sudo passwd # enter new password
# enable root ssh login
# sudo sed -i '' 's/^#PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config
# set up root ssh
# sudo ssh-keygen -f /var/root/.ssh/id_rsa -t rsa -N ''
# copy android ssh key to root mac
# echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3F613kOAYA6WfOvQWaHzxMhmeopLqqmCUnJy7iM2TpBqoYrkmp+nVg7mBhsBocO+C9kw5RwR6l0VHnmTQuXQ6YPV94pUciEfBxbI7GTJPFHY26qXq0aItvJ6n5lJPzk+m2CAX4QlCqpXij8peoHe9rhkTU87rEbZA2dkd20nJCLy9LwGLJkkENyX5xX+WbLjJlYHFrkTJyd0ir1uI5zI9pV2v+utHBw4mBOBCO4iAQzqbEV7DNjIV6MEU6paBIoBdqOmTup3DEXonDGsthxGof/Sr8B//NHzGU5OBWlTACPO+S6BtuPeecSoM3I0sGWIbw+bZT/85Fx0Li4+tyoNd (null)@localhost' | sudo tee --append /var/root/.ssh/authorized_keys
#
# from mac:
# adb reverse tcp:2223 tcp:22
# from android adb shell or ssh over other forwarded port:
# cat /data/data/com.arachnoid.sshelper/home/.ssh/id_rsa.pub
# ssh -i'/data/data/com.arachnoid.sshelper/home/.ssh/id_rsa' -oStrictHostKeyChecking=no -p2223 root@127.0.0.1
#
# rsync -av -e 'ssh -oProxyCommand="adb-channel tcp:2222 com.arachnoid.sshelper/.SSHelperActivity 1"' -n localhost:/storage/emulated/0
# rsync -avzH -P --delete --delete-excluded --force --numeric-ids -e 'ssh -oProxyCommand="adb-channel tcp:2222 com.arachnoid.sshelper/.SSHelperActivity 1"' -n localhost:/storage/emulated/0/ /Volumes/Striped/Backups/Phones/Nexus6P
# rsync -avzH -P --delete --delete-excluded --force -e 'ssh -oProxyCommand="adb-channel tcp:2222 com.arachnoid.sshelper/.SSHelperActivity 1"' localhost:/storage/emulated/0/ /Volumes/Striped/Backups/Phones/Nexus6P

# sudo su root -c 'cd /Volumes/Striped/Backups/Phones/current/data/media/0 && pax -rwl * ../../../../Nexus6Pe'

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
duti -s com.sublimetext.3 .log all
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
