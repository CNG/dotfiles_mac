#######################################
# Install Homebrew or Linuxbrew if not detected.
# Globals:
#   None
# Arguments:
#   indent  (string) Optional text to prepend to messages
# Returns:
#   None
#######################################
install_brew () {
  if test ! $(which brew); then
    local indent=${1:-} # empty string unless second param set
    if [[ $OSTYPE == darwin* ]]; then
      info "${indent}Installing Homebrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    elif [[ $OSTYPE == linux* ]]; then
      info "${indent}Installing Linuxbrew dependencies."
      if [[ -n "$(command -v yum)" ]]; then
        sudo yum groupinstall 'Development Tools' && sudo yum install curl file git irb python-setuptools ruby
      elif [[ -n "$(command -v apt-get)" ]]; then
        sudo apt-get install build-essential curl file git python-setuptools ruby
      fi
      info "${indent}Installing Linuxbrew."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    fi
    okay "Done."
  fi
}

install_brew
