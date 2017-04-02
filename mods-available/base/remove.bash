#######################################
# Remove dotfiles command.
# Globals:
#   APP_ROOT  (string) Path to dotfiles project.
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
remove_command () {
  local lvl=${1:-0} # 0 unless second param set
  local bin=/usr/local/bin/dotfiles
  info $lvl "Removing dotfiles command."
  if rm -f "$bin"; then
    okay $lvl "Done."
  else
    fail $lvl "Could not delete dotfiles command at $(fmt bold "$bin")."
    return 1
  fi
}

#######################################
# Remove Homebrew or Linuxbrew.
# Globals:
#   None
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
remove_brew () {
  if test $(which brew); then
    local lvl=${1:-0} # 0 unless second param set
    if [[ $OSTYPE == darwin* ]]; then
      info $lvl "Removing Homebrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    elif [[ $OSTYPE == linux* ]]; then
      info $lvl "Linuxbrew dependencies require attention, as they may have existed before. NOT running:"
      if [[ -n "$(command -v yum)" ]]; then
        echo 'sudo yum groupremove '"'"'Development Tools'"'"' && sudo yum remove curl file git irb python-setuptools ruby'
      elif [[ -n "$(command -v apt-get)" ]]; then
        echo 'sudo apt-get remove build-essential curl file git python-setuptools ruby'
      fi
      info $lvl "Removing Linuxbrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/uninstall)"
    fi
    okay $lvl "Done."
  fi
}

remove_command $lvl3
remove_brew $lvl3
