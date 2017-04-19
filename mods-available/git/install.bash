#######################################
# Create local Git config file based on user input.
# Basically lifted from @holman/dotfiles.
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   Prints actions taken.
#######################################
create_local_config() {
  local modpath=$MODS_ALL/git
  local lvl=${1:-0} # 0 unless second param set
  local target_file=$modpath/gitconfig.local.symlink
  if [[ ! -f $target_file ]]; then
    info $lvl 'Creating local Git config.'

    local git_credential='cache'
    if [[ $(uname -s) = 'Darwin' ]]; then
      git_credential='osxkeychain'
    fi

    #local git_authorname git_authoremail
    user $lvl "$(fmt bold 'What is your Github author name?')"
    read -e git_authorname
    user $lvl "$(fmt bold 'What is your Github author email?')"
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" "$target_file.example" > "$target_file"

    okay $lvl 'Local Git config created and will be installed on next update.'
  fi
}

create_local_config $lvl3
