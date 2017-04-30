loginitems -a 'RescueTime' -s false
defaults write com.rescuetime.RescueTime.plist SUEnableAutomaticChecks 1
defaults write com.rescuetime.RescueTime.plist SUHasLaunchedBefore 1

loginitems -a 'Scroll Reverser'
defaults write com.pilotmoon.scroll-reverser HasRunBefore 1
defaults write com.pilotmoon.scroll-reverser ReverseMouse 1
defaults write com.pilotmoon.scroll-reverser ReverseTablet 0
defaults write com.pilotmoon.scroll-reverser ReverseTrackpad 0
defaults write com.pilotmoon.scroll-reverser ReverseX 0
defaults write com.pilotmoon.scroll-reverser ReverseY 1
defaults write com.pilotmoon.scroll-reverser SUEnableAutomaticChecks 1

loginitems -a "Retina DisplayMenu" -p "/Applications/RDM.app"

loginitems -a "Divvy"
defaults write com.mizage.Divvy defaultColumnCount 7
defaults write com.mizage.Divvy defaultRowCount 6
defaults write com.mizage.Divvy lastColumnCount 6
defaults write com.mizage.Divvy lastRowCount 6
defaults write com.mizage.Divvy shortcuts -data 62706c6973743030d40102030405064546582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a8070810292a31394155246e756c6cd2090a0b0f5a4e532e6f626a656374735624636c617373a30c0d0e8002800580068007dd11121314150a161718191a1b1c1d1e1f20212223212526271f285873697a65526f77735f100f73656c656374696f6e456e64526f775f101173656c656374696f6e5374617274526f775a7375626469766964656456676c6f62616c5f101273656c656374696f6e456e64436f6c756d6e57656e61626c65645b73697a65436f6c756d6e73576e616d654b65795c6b6579436f6d626f436f64655f101473656c656374696f6e5374617274436f6c756d6e5d6b6579436f6d626f466c61677310061005100008098004100109100780031021120010000050d22b2c2d2e5a24636c6173736e616d655824636c61737365735853686f7274637574a22f305853686f7274637574584e534f626a656374dd11121314150a161718191a1b1c1d1e1f2021221d212526371e3808098004098003101e1200100000dd11121314150a161718191a1b1c1d1e1f2021221d2125263f1f400809800409800310231200100000d22b2c42435e4e534d757461626c654172726179a3424430574e5341727261795f100f4e534b657965644172636869766572d1474854726f6f74800100080011001a0023002d0032003700400046004b0056005d006100630065006700690084008d009f00b300be00c500da00e200ee00f60103011a0128012a012c012e012f013001320134013501370139013b0140014101460151015a01630166016f017801930194019501970198019a019c01a101bc01bd01be01c001c101c301c501ca01cf01de01e201ea01fc01ff02040000000000000201000000000000004900000000000000000000000000000206
defaults write com.mizage.Divvy showMenuIcon 0
defaults write com.mizage.Divvy useDefaultGrid 1

loginitems -a 'Clipboard History' -s false
defaults write com.agileroute.clipboardhistory ClearHistoryOnExit 0
defaults write com.agileroute.clipboardhistory FirstLaunch 0
defaults write com.agileroute.clipboardhistory HotkeyActivations 0
defaults write com.agileroute.clipboardhistory LastSelectedPage 0
defaults write com.agileroute.clipboardhistory MaxHistorySize 1000 # UI max is 500
defaults write com.agileroute.clipboardhistory MaxMenuSize 1000 # UI max is 500
defaults write com.agileroute.clipboardhistory NotifyNewClipboardItem 0
defaults write com.agileroute.clipboardhistory PlaySounds 0

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

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

killall "Google Chrome Canary" || true
killall "Google Chrome" || true

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

# Expand the print dialog by default
defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

killall Opera || true

###############################################################################
# SizeUp.app                                                                  #
###############################################################################

# Start SizeUp at login
# defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

# Don’t show the preferences window on next start
# defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

# killall SizeUp

###############################################################################
# Transmission.app                                                            #
###############################################################################

# # Use `~/Documents/Torrents` to store incomplete downloads
# defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
# defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# # Use `~/Downloads` to store completed downloads
# defaults write org.m0k.transmission DownloadLocationConstant -bool true

# # Don’t prompt for confirmation before downloading
# defaults write org.m0k.transmission DownloadAsk -bool false
# defaults write org.m0k.transmission MagnetOpenAsk -bool false

# # Don’t prompt for confirmation before removing non-downloading active transfers
# defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# # Trash original torrent files
# defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# # Hide the donate message
# defaults write org.m0k.transmission WarningDonate -bool false
# # Hide the legal disclaimer
# defaults write org.m0k.transmission WarningLegal -bool false

# # IP block list.
# # Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
# defaults write org.m0k.transmission BlocklistNew -bool true
# defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
# defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# # Randomize port on launch
# defaults write org.m0k.transmission RandomPort -bool true

# killall Transmission
