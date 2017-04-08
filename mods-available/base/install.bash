#######################################
# Install dotfiles command.
# Globals:
#   APP_ROOT  (string) Path to dotfiles project.
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
install_command () {
  local lvl=${1:-0} # 0 unless second param set
  info $lvl "Installing dotfiles command."
  link_file "$APP_ROOT/dotfiles" "/usr/local/bin" $lvl
  okay $lvl "Done."
}

#######################################
# Install Homebrew or Linuxbrew if not detected.
# Globals:
#   None
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
install_brew () {
  if test ! $(which brew); then
    local lvl=${1:-0} # 0 unless second param set
    if [[ $OSTYPE == darwin* ]]; then
      info $lvl "Installing Homebrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    elif [[ $OSTYPE == linux* ]]; then
      info $lvl "Installing Linuxbrew dependencies."
      if [[ -n "$(command -v yum)" ]]; then
        sudo yum groupinstall 'Development Tools' && sudo yum install curl file git irb python-setuptools ruby
      elif [[ -n "$(command -v apt-get)" ]]; then
        sudo apt-get install build-essential curl file git python-setuptools ruby
      fi
      info $lvl "Installing Linuxbrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    fi
    okay $lvl "Done."
  fi
}

install_command $lvl3
install_brew $lvl3
