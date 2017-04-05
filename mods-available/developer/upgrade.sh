#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
upgrade_developer() {
  local modpath=$MODS_ALL/developer
  local lvl=${1:-0} # 0 unless second param set

  # Install Sublime Text settings
  local src="$modpath/Preferences.sublime-settings"
  local dst="$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
  if ! cmp --silent "$src" "$dst"; then
    info $lvl 'Updating Sublime Text config.'
    cp -f "$src" "$dst" 2> /dev/null
  fi


}

upgrade_developer $lvl3

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
