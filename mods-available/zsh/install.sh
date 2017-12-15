#sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
#chsh -s $(which zsh)

# need to see if this is redundant with above for using brew zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Powerline fonts for oh-my-zsh theme
rm -rf /tmp/powerlinefonts
git clone https://github.com/powerline/fonts.git /tmp/powerlinefonts
/tmp/powerlinefonts/install.sh
rm -rf /tmp/powerlinefonts
# TODO: add undo

# Disable path_helper since we manage $PATH separately
[[ ! -x /usr/libexec/path_helper ]] || sudo chmod -x /usr/libexec/path_helper || true

# Ignore insecure directories and continue [y] or abort compinit [n]?
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh

# highlight_dir="$(find /usr/local/Cellar/source-highlight/ -path "*/share/source-highlight" -print -quit)"
# if [[ ! -f $highlight_dir/esc-solarized.style ]]; then
#  temp_dir=/tmp/source-highlight-solarized
#  git clone https://github.com/jrunning/source-highlight-solarized.git "$temp_dir"
#  cp -a "$temp_dir/esc-solarized.outlang" "$highlight_dir"
#  cp -a "$temp_dir/esc-solarized.style" "$highlight_dir"
#  rm -rf "$temp_dir"
#fi
## https://github.com/jrunning/source-highlight-solarized/issues/3
#if ! grep "esc-solarized" "$highlight_dir/outlang.map"; then
#  echo "esc-solarized = esc-solarized.outlang" >> "$highlight_dir/outlang.map"
#fi
# TODO: add undo

highlight_dir="$(find /usr/local/Cellar/highlight/ -path "*/share/highlight/langDefs" -print -quit)"
if [[ ! -f $highlight_dir/json.lang ]]; then
  cp -a "$highlight_dir/js.lang" "$highlight_dir/json.lang"
fi


# https://gist.github.com/textarcana/4611277#gistcomment-1701305
# Setup JSON Syntax Highlighting
# Copy js.lang to json.lang with the following command
# cp "$(dirname $(brew list highlight | head -n 1))/share/highlight/langDefs/js.lang" "$(dirname $(brew list highlight | head -n 1))/share/highlight/langDefs/json.lang"
