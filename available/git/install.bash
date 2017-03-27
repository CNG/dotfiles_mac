MODULE_PATH=$MODS_AVAILABLE/git
readonly MODULE_PATH

#######################################
# Create local Git config file based on user input.
# Basically lifted from @holman/dotfiles.
# Globals:
#   MODULE_PATH (string) Path to this module.
# Arguments:
#   None
# Returns:
#   Prints actions taken.
#######################################
create_local_config() {
  local target_file=$MODULE_PATH/gitconfig.local.symlink
  if [[ ! -f $target_file ]]; then
    info "${indent}- Creating local Git config."

    local git_credential='cache'
    if [[ $(uname -s) = 'Darwin' ]]; then
      git_credential='osxkeychain'
    fi

    #local git_authorname git_authoremail
    user "${indent}- $(fmt bold 'What is your Github author name?')"
    read -e git_authorname
    user "${indent}- $(fmt bold 'What is your Github author email?')"
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" "$target_file.example" > "$target_file"

    okay "{indent}- Local Git config created and will be installed on next update."
  fi
}

create_local_config
