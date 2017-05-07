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
  local src dst

  # Sublime Text settings
  src="$modpath/sublime/User"
  dst="$HOME/Library/Application Support/Sublime Text 3/Packages"
  mkdir -p "$dst" &&
  link_file "$src" "$dst" $lvl

  # iTerm2 settings
  src="$modpath/iterm2"
  dst="$HOME/.config"
  link_file "$src" "$dst" $lvl
  # # these are replicated in defaults folder but leaving here for now
  # defaults write com.googlecode.iterm2 SUHasLaunchedBefore 1
  # defaults write com.googlecode.iterm2 PrefsCustomFolder "~/.config/iterm2"
  # defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder 1
  # # Don’t display the annoying prompt when quitting iTerm
  # defaults write com.googlecode.iterm2 PromptOnQuit -bool false
}

upgrade_developer $lvl3
