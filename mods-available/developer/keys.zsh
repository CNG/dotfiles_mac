# Pipe my public key to my clipboard.
# Set custom in ~/.zshenv.local
if [[ ! $PUBLIC_KEY ]]; then
  PUBLIC_KEY=$HOME/.ssh/id_rsa.pub
fi

alias pubkey="more $PUBLIC_KEY | pbcopy | echo '=> Public key copied to pasteboard.'"
