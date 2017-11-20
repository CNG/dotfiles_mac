
#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
install_macos() {
  local modpath=$MODS_ALL/hackintosh
  local lvl=${1:-0} # 0 unless second param set
  local src dst

  # Karabiner Elements
  src=$modpath/karabiner.json
  dst=$HOME/.config/karabiner
  mkdir -p "$dst"
  dst=$dst/karabiner.json
  link_file "$src" "$dst" $lvl
}

install_macos $lvl3
