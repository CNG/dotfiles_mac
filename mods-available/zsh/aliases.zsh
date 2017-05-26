alias reload!='. ~/.zshenv; . ~/.zshrc'
alias br=". ~/.zshenv; . ~/.zshrc"

alias cls='clear' # Good 'ol Clear Screen command

# Following alias fails on symbolic links to nonexitent files
# alias rm='trash'
# See https://github.com/ali-rantakari/trash/issues/22
# Workaround:
rm () { [[ -e ${1: -1} ]] && trash "$@" || /bin/rm "$@" }

# http://unix.stackexchange.com/a/18092/39419
bashman () { man bash | less -p "^       $1 "; }

zshman () { man zshbuiltins | less -p "^       $1 "; }
