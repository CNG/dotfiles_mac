alias reload!='. ~/.zshenv; . ~/.zshrc'
alias br=". ~/.zshenv; . ~/.zshrc"

alias cls='clear' # Good 'ol Clear Screen command

alias rm='trash'

# http://unix.stackexchange.com/a/18092/39419
bashman () { man bash | less -p "^       $1 "; }

zshman () { man zshbuiltins | less -p "^       $1 "; }
