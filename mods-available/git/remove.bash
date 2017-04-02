#######################################
# Delete local Git config file.
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
# Arguments:
#   lvl      (int)    Indentation level.
# Returns:
#   None
#######################################
delete_local_config() {
  local path=$MODS_ALL/git
  local lvl=${1:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local target_file=$path/gitconfig.local.symlink
  if [[ -f $target_file ]]; then
    info $lvl 'Deleting local Git config.'
    trash_file "$target_file" $lvl2
  fi
}

delete_local_config $lvl3
