#add each topic folder to fpath so that they can add functions and completion scripts
for module ($DOTFILES/mods-enabled/*) if [ -d $module ]; then  fpath=($module $fpath); fi;
