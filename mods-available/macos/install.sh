# I don't want to upgrade OSX itself on my desktop, need to investigate
# Also using mas-cli with brew...
# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a

# TODO: add undo
# allow sudo without password
#sudo sed -i 's|^[[:space:]#]+(%wheel[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]*NOPASSWD:[[:space:]]*ALL.*)|\1|' /etc/sudoers
#sudo dscl . append /Groups/wheel GroupMembership $(whoami)

loginitems -a "Retina DisplayMenu" -p "/Applications/RDM/RDM.app"
loginitems -a "Divvy"

# Mountain Lion deletes the file /etc/crontab which is needed for crontab to run.
# If you plan to use scheduled job with cron, you need to type the following command to enable it:
sudo touch /etc/crontab
