#######################################
# Tests the link_file function with simple end result sanity check when using
# overwrite_all=true or backup_all=true or skip_all=true.
# Globals:
#   link_file  (function)
# Arguments:
#   None
# Returns:
#   Prints actions taken.
#######################################
link_file_test () {
  local tests=(overwrite_all backup_all skip_all)
  for testing in "${tests[@]}"; do
    info "$(fmt bold "$testing=true") test commencing."
    eval ${testing}=true

    # set up files
    mkdir -p sources
    mkdir -p links
    touch sources/file1.symlink
    touch links/file2
    touch sources/file3.symlink
    touch links/file3
    link_file "sources/file1.symlink" "links/file1"
    if link_file "sources/file2.symlink" "links/file2" > /dev/null; then
      fail "$(fmt bold link_file) did not fail despite" \
        "$(fmt bold 'sources/file2.symlink') not existing."
    else
      touch sources/file2.symlink
      link_file "sources/file2.symlink" "links/file2"
    fi
    link_file "sources/file3.symlink" "links/file3"

    # verify files
    list=$(ls -l links sources)
    expectations=()
    expectations+=('file1 -> sources/file1.symlink')
    if [[ $testing != 'skip_all' ]]; then
      expectations+=('file2 -> sources/file2.symlink')
      expectations+=('file3 -> sources/file3.symlink')
    fi
    if [[ $testing = 'backup_all' ]]; then
      expectations+=('file2\.[_0-9]{15}\.backup')
      expectations+=('file3\.[_0-9]{15}\.backup')
    fi
    for i in "${expectations[@]}"; do
      if [[ ! $list =~ $i ]]; then
        fail "Test of $(fmt bold link_file) failed to find $(fmt bold "$i")"
        return 1
      fi
    done

    # clean up this subtest
    eval ${testing}=false
    rm -rf sources
    rm -rf links
  done
  okay "Test of $(fmt bold link_file) completed."
}

main_tests () {
  local temp_dir="$APP_ROOT/_tests_$(date "+%Y%m%d_%H%M%S")"
  mkdir "$temp_dir"
  cd "$temp_dir"

  link_file_test

  cd ..
  rm -rf "$temp_dir"
}