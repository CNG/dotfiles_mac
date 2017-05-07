#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
install_productivity_extra() {
  local modpath=$MODS_ALL/productivity_extra
  local lvl=${1:-0} # 0 unless second param set
}

install_productivity_extra $lvl3
