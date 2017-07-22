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

  # Need to think about best way to do Vim, and Sublime, since
  # I don't like symlinking directories into dotfiles

  # TODO: convert these to git pull if folder exists
  
  # Install pathogen.vim but to bundle folder, requiring in .vimrc:
  #   runtime bundle/vim-pathogen/autoload/pathogen.vim
  mkdir -p ~/.vim/bundle
  # curl -LSso ~/.vim/bundle/pathogen.vim https://tpo.pe/pathogen.vim
  cd ~/.vim/bundle
  git clone git://github.com/tpope/vim-pathogen.git || true
  git clone git://github.com/tpope/vim-repeat.git || true
  git clone git://github.com/tpope/vim-surround.git || true
  git clone git://github.com/tpope/vim-speeddating.git || true
  # this looks interesting, but I am doing too much new stuff already
  # git clone git://github.com/tpope/vim-abolish.git || true
  git clone git://github.com/tpope/vim-commentary.git || true
  git clone https://github.com/scrooloose/nerdcommenter.git || true

  # SnipMate
  git clone https://github.com/tomtom/tlib_vim.git || true
  git clone https://github.com/MarcWeber/vim-addon-mw-utils.git || true
  git clone https://github.com/garbas/vim-snipmate.git || true
  # Optional:
  git clone https://github.com/honza/vim-snippets.git || true



}

upgrade_developer $lvl3
