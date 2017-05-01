
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
  local package image volume

  link_file "$MAINSTORAGE/Documents/Projects" "$HOME/projects" $lvl

  # Karabiner Elements
  src=$modpath/karabiner.json
  dst=$HOME/.config/karabiner
  mkdir -p "$dst"
  dst=$dst/karabiner.json
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

  cd "$HOME/Downloads"

  # Install old IOReg
  curl -o ioreg.zip https://www.tonymacx86.com/attachments/ioregistryexplorer-slrid_v10-6-3-zip.24086/
  unzip ioreg.zip
  mv IORegistryExplorer-SLRID_v10.6.3/IORegistryExplorer.app /Applications
  rm -rf IORegistryExplorer-SLRID_v10.6.3 ioreg.zip

  # Install latest NVIDIA web driver
  curl -o nvidia.plist https://gfe.nvidia.com/mac-update
  package=$(/usr/libexec/PlistBuddy -c 'Print :updates:0:downloadURL' nvidia.plist)
  rm -f nvidia.plist
  curl -o WebDriver-latest.pkg "$package"
  sudo installer -pkg WebDriver-latest.pkg -target /
  rm -f WebDriver-latest.pkg

  # Install NVIDIA CUDA
  image=cudadriver-8.0.81-macos.dmg
  volume=/Volumes/CUDADriver
  curl -o $image http://us.download.nvidia.com/Mac/Quadro_Certified/8.0.81/$image
  open $image
  sudo installer -pkg $volume/CUDADriver.pkg -target /
  umount $volume
  rm -f $image

  # Install Fitbit Connect
  image=FitbitConnect-v2.0.1.6809-2016-08-09.dmg
  volume=/Volumes/FitbitConnect-v2.0.1.6809-2016-08-09
  curl -o $image http://cache.fitbit.com/FitbitConnect/$image
  open $image
  sudo installer -pkg $volume/Install\ Fitbit\ Connect.pkg -target /
  umount $volume
  rm -f $image

  cd -

  # same as in macos module but remove wifi and battery (which didn't show anyway)
  # TODO: use arrayremove/add command
  defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu"

}

install_hackintosh $lvl3
