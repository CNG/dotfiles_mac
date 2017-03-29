# Add each module's functions to fpath so they can add functions and completions
# and autoload contained functions

for module_functions ($DOTFILES/mods-enabled/***/functions)
  if [[ -d $module_functions ]]; then
    fpath=($module_functions $fpath)
  fi

autoload -U $DOTFILES/mods-enabled/***/functions/*(:t) # :t is like basename
