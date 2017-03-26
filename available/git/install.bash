create_local_config() {
  if [[ ! -f $MODS_AVAILABLE/git/gitconfig.local.symlink ]]; then
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

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" available/git/gitconfig.local.symlink.example > available/git/gitconfig.local.symlink

    okay "{indent}- Local Git config created and will be installed on next update."
  fi
}

create_local_config
