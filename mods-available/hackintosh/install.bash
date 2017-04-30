
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
  local package=$(/usr/libexec/PlistBuddy -c 'Print :updates:0:downloadURL' nvidia.plist)
  rm -f nvidia.plist
  curl -o WebDriver-latest.pkg "$package"
  sudo installer -pkg WebDriver-latest.pkg -target /
  rm -f WebDriver-latest.pkg

  # Install NVIDIA CUDA
  curl -o cudadriver.dmg http://us.download.nvidia.com/Mac/Quadro_Certified/8.0.81/cudadriver-8.0.81-macos.dmg
  open cudadriver.dmg
  sudo installer -pkg /Volumes/CUDADriver/CUDADriver.pkg -target /
  umount /Volumes/CUDADriver
  rm -f cudadriver.dmg

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
