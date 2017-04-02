sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
chsh -s $(which zsh)

# need to see if this is redundant with above for using brew zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
