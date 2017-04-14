
#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
install_hackintosh() {
  local modpath=$MODS_ALL/hackintosh
  local lvl=${1:-0} # 0 unless second param set
  local src dst

  # Karabiner Elements
  src="$modpath/karabiner.json"
  dst=~/.config/karabiner/karabiner.json
  link_file "$src" "$dst" $lvl

  # Enable accessibility settings
  # This is under hackintosh because only works if SIP disabled
  sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'UPDATE access SET allowed = "1";'

  # Make Desktop a symlink to storage
  src=$MAINSTORAGE/Desktop
  dst=$HOME/Desktop
  if [[ -d $dst && ! -h $dst && -d $src && ! -d $src/LocalDesktop ]]; then
    sudo mv $dst $src/LocalDesktop
    link_file "$src" "$HOME" $lvl
  fi

  # Install latest NVIDIA web driver
  cd "$HOME/Downloads"
  curl -o nvidia.plist https://gfe.nvidia.com/mac-update
  local package=$(/usr/libexec/PlistBuddy -c 'Print :updates:0:downloadURL' nvidia.plist)
  rm -f nvidia.plist
  curl -o WebDriver-latest.pkg "$package"
  sudo installer -pkg WebDriver-latest.pkg -target /
  rm -f WebDriver-latest.pkg
  cd -

}

install_hackintosh $lvl3
