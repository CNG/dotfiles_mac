
#######################################
#
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
install_developer() {
  local modpath=$MODS_ALL/developer
  local lvl=${1:-0} # 0 unless second param set

  # Install the Solarized Dark theme for iTerm
  open "$modpath/Solarized Dark.itermcolors"

  # dtrace: failed to initialize dtrace: DTrace requires additional privileges
  sudo chmod u+s /usr/sbin/dtrace


  # Need to think about best way to do Vim, and Sublime, since
  # I don't like symlinking directories into dotfiles

  # Install pathogen.vim but to bundle folder, requiring in .vimrc:
  #   runtime bundle/vim-pathogen/autoload/pathogen.vim
  mkdir -p ~/.vim/bundle &&
    curl -LSso ~/.vim/bundle/pathogen.vim https://tpo.pe/pathogen.vim
  cd ~/.vim/bundle
  git clone git://github.com/tpope/vim-repeat.git
  git clone git://github.com/tpope/vim-surround.git
  git clone git://github.com/tpope/vim-speeddating.git
  # this looks interesting, but I am doing too much new stuff already
  # git clone git://github.com/tpope/vim-abolish.git
  git clone git://github.com/tpope/vim-commentary.git
  git clone https://github.com/scrooloose/nerdcommenter.git

  # SnipMate
  git clone https://github.com/tomtom/tlib_vim.git
  git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
  git clone https://github.com/garbas/vim-snipmate.git
  # Optional:
  git clone https://github.com/honza/vim-snippets.git





}

install_developer $lvl3
