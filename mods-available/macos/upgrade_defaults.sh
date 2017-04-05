# Retrieve latest @
# mathiasbynens=$(curl -fsL https://github.com/mathiasbynens/dotfiles/raw/master/.macos)
# echo $mathiasbynens | sed '/#.*/d' | sed '/[[:space:]]+/d' |
# sed '/com.divisiblebyzero.Spectacle/d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 
# sed '//d' | 


defaults write com.mizage.Divvy defaultColumnCount 7
defaults write com.mizage.Divvy defaultRowCount 6
defaults write com.mizage.Divvy lastColumnCount 6
defaults write com.mizage.Divvy lastRowCount 6
defaults write com.mizage.Divvy shortcuts -data 62706c6973743030d401020304050847485424746f7058246f626a65637473582476657273696f6e59246172636869766572d1060754726f6f748001a8090a122b2c333b4355246e756c6cd20b0c0d0e5624636c6173735a4e532e6f626a656374738007a30f1011800280058006dd131415161718191a1b1c1d1e0b1f20212223202425262228292a5f101273656c656374696f6e456e64436f6c756d6e5f101173656c656374696f6e5374617274526f775c6b6579436f6d626f436f646557656e61626c65645d6b6579436f6d626f466c6167735f101473656c656374696f6e5374617274436f6c756d6e5b73697a65436f6c756d6e735a73756264697669646564576e616d654b657956676c6f62616c5f100f73656c656374696f6e456e64526f775873697a65526f777310011000102909120010000010070880030910051006800450d22d2e2f325824636c61737365735a24636c6173736e616d65a230315853686f7274637574584e534f626a6563745853686f7274637574dd131415161718191a1b1c1d1e0b2920342236282425262228292a1027091200100000088003098004dd131415161718191a1b1c1d1e0b29203c223e202425262228292a1025091200100000088003098004d22d2e4445a34546315e4e534d757461626c654172726179574e53417272617912000186a05f100f4e534b657965644172636869766572000800110016001f002800320035003a003c0045004b00500057006200640068006a006c006e0089009e00b200bf00c700d500ec00f80103010b01120124012d012f0131013301340139013b013c013e013f0141014301450146014b0154015f0162016b0174017d0198019a019b01a001a101a301a401a601c101c301c401c901ca01cc01cd01cf01d401d801e701ef01f40000000000000201000000000000004900000000000000000000000000000206
defaults write com.mizage.Divvy showMenuIcon 0
defaults write com.mizage.Divvy useDefaultGrid 1

defaults write com.mouapp.Mou autoPairCheckerKeyString 0
defaults write com.mouapp.Mou lineSpaceCheckerKeyString 8
defaults write com.mouapp.Mou livePreviewCheckerKeyString 1
defaults write com.mouapp.Mou mathCheckerKeyString 0
defaults write com.mouapp.Mou openDonateLinkKeyString 0
defaults write com.mouapp.Mou selectedCSSKeyString Clearness
defaults write com.mouapp.Mou selectedFontNameKeyString Georgia
defaults write com.mouapp.Mou selectedFontSizeKeyString 24
defaults write com.mouapp.Mou selectedThemeKeyString "Tomorrow+"
defaults write com.mouapp.Mou showHelpDocumentKeyString 0
defaults write com.mouapp.Mou softTabCheckerKeyString 1
defaults write com.mouapp.Mou spellCheckerKeyString 1
defaults write com.mouapp.Mou syncScrollCheckerKeyString 1


# TODO: abstract this
scutil --set HostName "CharlieDesktop"

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Disable Notification Center
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
killall NotificationCenter

# Delete Apple Crap
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/iTunes.app

defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write com.apple.Finder QuitMenuItem -bool YES

defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# https://mercier.link/blog/posts/preventdsstore.php
# http://www.aorensoftware.com/Downloads/Files/DeathToDSStore.zip

# Disable gatekeeper, but don't have a specific need for this that i know of
# sudo spctl --master-disable

# go through https://github.com/mathiasbynens/dotfiles/blob/master/.macos again


# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 1

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the bottom-left hot corner.
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

killall Finder
killall Dock
