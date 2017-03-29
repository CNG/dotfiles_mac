#######################################
# Delete local Git config file.
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
#   lvl      (int)    Indentation level.
# Arguments:
#   None
# Returns:
#   None
#######################################
delete_local_config() {
  local path=$MODS_ALL/git
  local target_file=$path/gitconfig.local.symlink
  if [[ -f $target_file ]]; then
    info $lvl2 'Deleting local Git config.'
    trash_file "$target_file" $((lvl2+1))
  fi
}

delete_local_config
