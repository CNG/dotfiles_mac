#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
remove_hackintosh() {
  local lvl=${1:-0} # 0 unless second param set
  local dst

  # Karabiner Elements
  dst=$HOME/.config/karabiner
  trash_file "$dst" $lvl
}

remove_hackintosh $lvl3
