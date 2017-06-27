# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a


# Disable Gatekeeper, which produces messages like
# "…can't be opened because it is from an unidentified developer"
[[ $(spctl --status) = *disabled* ]] || sudo spctl --master-disable




# This does not survive reboot. Need 'UseKeychain yes' in ~/.ssh/config
# load identities from keychain
# ssh-add -A

# turn on keychain (i forgot if this is a one time thing or needs to be added to startup)
keychain

defaults write NSGlobalDomain com.apple.springing.delay -float 1

defaults write com.apple.finder.plist arrangeBy dateModified

# allow sudo without password
# TODO this command works pasted but not from script, still need to debug
# plus it's not wise to not use visudo anyway...
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
# maybe just do echo '%wheel          ALL = (ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
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

# open_with org.videolan.vlc MPG AVI
open_with () {
  local domain=$1 && shift
  local arr=($@)
  for ext in "${arr[@]}"; do
    duti -s $domain .$ext all
  done
}
open_with org.videolan.vlc ASX DTS GXF M2V M3U M4V MPEG1 MPEG2 MTS MXF OGM PLS BUP A52 AAC B4S CUE DIVX DV FLV M1V M2TS MKV MOV MPEG4 OMA SPX TS VLC VOB XSPF DAT BIN IFO PART 3G2 AVI MPEG MPG FLAC M4A MP1 OGG WAV XM 3GP SRT WMV AC3 ASF MOD MP2 MP3 MP4 WMA MKA M4P
open_with com.sublimetext.3 txt py php sh bash log
open_with com.uranusjr.macdown md markdown

# Don't warn "You are opening the application “VLC” for the first time. Are you sure you want to open this application?"
defaults write com.apple.LaunchServices LSQuarantine -bool NO

# try to set hostname etc based on system config
set_hostname () {
  [[ $(which finger) ]] || return 0 # not a mac
  first_name=$(finger $(whoami) | perl -ne '/Name: ([a-zA-Z0-9]{1,})/ && print "$1\n"')
  if [[ $(sysctl -n hw.model | grep "Book") ]]; then
    host_name="${first_name}Laptop"
  else
    host_name="${first_name}Desktop"
  fi
  [[ $(scutil --get HostName     ) = $host_name ]] || sudo scutil --set HostName      "$host_name"
  [[ $(scutil --get LocalHostName) = $host_name ]] || sudo scutil --set LocalHostName "$host_name"
  [[ $(scutil --get ComputerName ) = $host_name ]] || sudo scutil --set ComputerName  "$host_name"
}
set_hostname


# Delete Apple Crap
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/iTunes.app
loginitems -d 'iTunesHelper'

# https://mercier.link/blog/posts/preventdsstore.php
# http://www.aorensoftware.com/Downloads/Files/DeathToDSStore.zip

# Disable gatekeeper, but don't have a specific need for this that i know of
# sudo spctl --master-disable

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

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Nothing
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Nothing
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Show application windows
defaults write com.apple.dock wvous-br-corner -int 3
defaults write com.apple.dock wvous-br-modifier -int 0
