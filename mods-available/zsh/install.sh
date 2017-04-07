#sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
#chsh -s $(which zsh)

# need to see if this is redundant with above for using brew zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Powerline fonts for oh-my-zsh theme
rm -rf /tmp/powerlinefonts
git clone https://github.com/powerline/fonts.git /tmp/powerlinefonts
/tmp/powerlinefonts/install.sh
rm -rf /tmp/powerlinefonts
# TODO: add undo

# Disable path_helper since we manage $PATH separately
[[ ! -x /usr/libexec/path_helper ]] || sudo chmod -x /usr/libexec/path_helper
