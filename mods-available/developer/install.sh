
#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
install_developer() {
  local modpath=$MODS_ALL/developer
  local lvl=${1:-0} # 0 unless second param set

  # Install the Solarized Dark theme for iTerm
  open "$modpath/Solarized Dark.itermcolors"

  # dtrace: failed to initialize dtrace: DTrace requires additional privileges
  sudo chmod u+s /usr/sbin/dtrace

}

install_developer $lvl3
