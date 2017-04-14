#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
remove_developer() {
  local modpath=$MODS_ALL/developer
  local lvl=${1:-0} # 0 unless second param set
  local dst

  # Sublime Text settings
  dst="$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
  trash_file "$dst" $lvl

  # iTerm settings
  dst=~/.config/com.googlecode.iterm2.plist
  trash_file "$dst" $lvl
  defaults write com.googlecode.iterm2 PrefsCustomFolder ""
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder 0
}

remove_developer $lvl3
