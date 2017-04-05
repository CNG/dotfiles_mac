# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a

# allow sudo without password
# TODO this command works pasted but not from script, still need to debug
# plus it's not wise to not use visudo anyway...
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
#sudo dscl . append /Groups/wheel GroupMembership $(whoami)

loginitems -a "Retina DisplayMenu" -p "/Applications/RDM/RDM.app"
loginitems -a "Divvy"

# Mountain Lion deletes the file /etc/crontab which is needed for crontab to run.
# If you plan to use scheduled job with cron, you need to type the following command to enable it:
[[ -f /etc/crontab ]] || sudo touch /etc/crontab

# TODO: abstract this
scutil --set HostName "CharlieDesktop"

# Delete Apple Crap
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/iTunes.app

# https://mercier.link/blog/posts/preventdsstore.php
# http://www.aorensoftware.com/Downloads/Files/DeathToDSStore.zip

# Disable gatekeeper, but don't have a specific need for this that i know of
# sudo spctl --master-disable
