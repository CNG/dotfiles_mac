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
  local tests=(skip_all overwrite_all backup_all)
  for testing in "${tests[@]}"; do
    info "$(fmt bold "conflict_action=$testing") test commencing."
    local conflict_action=$testing

    # set up files
    mkdir -p sources
    for i in {1..4}; do mkdir -p links/$i; done

    echo "A" > sources/file1.symlink
    echo "C" > sources/file3.symlink
    echo "D" > sources/file4.symlink
    link_file "../../sources/file1.symlink"  "links/1/file1.symlink"
    link_file "$(pwd)/sources/file1.symlink" "links/3/_file1.symlink"

    link_file "../../sources/file2.symlink"  "links/1/file2" > /dev/null &&
      fail "link_file did not fail despite ../../sources/file2.symlink not existing."
    link_file "$(pwd)/sources/file2.symlink" "links/3/_file2" > /dev/null &&
      fail "link_file did not fail despite $(pwd)/sources/file2.symlink not existing."
    echo "B" > sources/file2.symlink
    link_file "../../sources/file2.symlink"  "links/1/file2"
    link_file "$(pwd)/sources/file2.symlink" "links/3/_file2"

    link_file "../../sources/file3.symlink"  "links/1/"
    link_file "$(pwd)/sources/file3.symlink" "links/3/"
    link_file "../../sources/file4.symlink"  "links/1"
    link_file "$(pwd)/sources/file4.symlink" "links/3"
    link_file "../../sources/file1.missing"  "links/2/_file1.symlink" > /dev/null &&
      fail "link_file did not fail despite ../../sources/file1.missing not existing."
    link_file "../../sources/file2.missing"  "links/2/_file2" > /dev/null &&
      fail "link_file did not fail despite ../../sources/file2.missing not existing."
    link_file "../../sources/file3.missing"  "links/2/" > /dev/null &&
      fail "link_file did not fail despite ../../sources/file3.missing not existing."
    link_file "../../sources/file4.missing"  "links/2" > /dev/null &&
      fail "link_file did not fail despite ../../sources/file4.missing not existing."
    link_file "../../sources"         "links/1/sources/" > /dev/null &&
      fail "link_file did not fail despite links/1/sources/ not being a directory."
    link_file "../../sources/others"  "links/1/others/" > /dev/null &&
      fail "link_file did not fail despite links/1/others/ not being a directory."
    link_file "../../missing"         "links/2/sources" > /dev/null &&
      fail "link_file did not fail despite ../../missing not existing."
    link_file "../../missing/others"  "links/2/others" > /dev/null &&
      fail "link_file did not fail despite ../../missing/others not existing."

    link_file "../../sources"         "links/3/"
    link_file "$(pwd)/sources"        "links/4/sources"
    link_file "../../sources/others"  "links/3" > /dev/null &&
      fail "link_file did not fail despite ../../sources/others not existing."
    link_file "$(pwd)/sources/others" "links/4/others" > /dev/null &&
      fail "link_file did not fail despite $(pwd)/sources/others not existing."
    mkdir sources/others
    touch sources/others/hello
    link_file "../../sources/others"  "links/3"
    link_file "$(pwd)/sources/others" "links/4/others"

    link_file "../1" "links/1" # makes link 1 inside dir links/1
    if [[ $conflict_action =~ ^(backup|overwrite) ]]; then
      link_file "1" "links/"
      link_file "1" "links"
    else
      link_file "1" "links/" # already exists, but gets skipped
      link_file "1" "links" # already exists, but gets skipped
    fi

    confirm_filecount '.'              2
    if [[ $conflict_action =~ ^backup ]]; then
      confirm_filecount 'links'        5
    else
      confirm_filecount 'links'        4
    fi
    if ! [[ $conflict_action =~ ^(backup|overwrite) ]]; then
      confirm_filecount 'links/1'      5
    fi
    confirm_filecount 'links/2'        0
    confirm_filecount 'links/3'        6
    confirm_filecount 'links/4'        2
    confirm_filecount 'sources'        5
    confirm_filecount 'sources/others' 1

    if ! [[ $conflict_action =~ ^(backup|overwrite) ]]; then
      confirm_symlink "../../sources/file1.symlink" "links/1/file1.symlink"
      confirm_symlink "../../sources/file2.symlink" "links/1/file2"
      confirm_symlink "../../sources/file3.symlink" "links/1/file3.symlink"
      confirm_symlink "../../sources/file4.symlink" "links/1/file4.symlink"
    fi
    confirm_symlink "$(pwd)/sources/file1.symlink" "links/3/_file1.symlink"
    confirm_symlink "$(pwd)/sources/file2.symlink" "links/3/_file2"
    confirm_symlink "$(pwd)/sources/file3.symlink" "links/3/file3.symlink"
    confirm_symlink "$(pwd)/sources/file4.symlink" "links/3/file4.symlink"
    confirm_symlink "../../sources"                "links/3/sources"
    confirm_symlink "../../sources/others"         "links/3/others"
    confirm_symlink "$(pwd)/sources"               "links/4/sources"
    confirm_symlink "$(pwd)/sources/others"        "links/4/others"
    if [[ $conflict_action =~ ^(backup|overwrite) ]]; then
      confirm_symlink "1"                          "links/1"
    fi

    # Previous ls output based checks
    # list=$(ls -l links sources)
    # expectations=()
    # expectations+=('file1 -> sources/file1.symlink')
    # if [[ $conflict_action != 'skip_all' ]]; then
    #   expectations+=('file2 -> sources/file2.symlink')
    #   expectations+=('file3 -> sources/file3.symlink')
    # fi
    # if [[ $conflict_action = 'backup_all' ]]; then
    #   expectations+=('file2\.[_0-9]{15}\.backup')
    #   expectations+=('file3\.[_0-9]{15}\.backup')
    # fi
    # for i in "${expectations[@]}"; do
    #   if [[ ! $list =~ $i ]]; then
    #     fail "Test of $(fmt bold link_file) failed to find $(fmt bold "$i")"
    #     return 1
    #   fi
    # done

    # clean up this subtest
    rm -rf sources
    rm -rf links
    echo
  done
  okay "Test of $(fmt bold link_file) completed."
}

#######################################
# Checks if number of items listed by `ls -1q` for a directory is as expected.
# Globals:
#   None
# Arguments:
#   name      (string) Directory to count files and folders
#   expected  (int) Number of files expected
# Returns:
#   None
#######################################
confirm_filecount () {
  local name=$1
  if [[ ! -d $name ]]; then
    fail "Not a folder: $name"
    return 1
  fi
  local expected=$2
  local actual=$(ls -1q "$name" | wc -l | tr -d '[:space:]')
  local result="File count: expected: $expected; actual: $actual; folder: $name"
  (( actual == expected )) && okay "$result" || fail "$result"
}

#######################################
# Checks if symbolic link points to the expected location and the link resolves
# to the same content as the content at the expected location.
# Globals:
#   None
# Arguments:
#   name      (string) Directory to count files and folders
#   expected  (int) Number of files expected
# Returns:
#   None
#######################################
# $name must be relative
confirm_symlink () {
  local expected=$1
  local name=$2
  local actual=$(readlink "$name")
  local norm_src=$actual
  # resolve relative $src for existence test
  [[ $actual != /* ]] && norm_src=$(resolve_parents "$name/../$actual")

  if [[ ! -h $name || -z $actual ]]; then
    fail "Not a symbolic link: $name"
    return 1
  elif [[ -f $name && ! -f $norm_src ]]; then
    fail "File symbolic link ($name) points to nonfile ($norm_src)"
    return 1
  elif [[ -d $name && ! -d $norm_src ]]; then
    fail "Directory symbolic link ($name) points to nondirectory ($actual)"
    return 1
  fi

  local result="Link source: expected: $expected; actual: $actual; name: $name"
  [[ $actual = $expected ]] && okay "$result" || fail "$result"

  if [[ ! -d $name && $(basename "$name") != $actual ]]; then
    expected=$(cd "$(pwd)/${name%/*}" && cat "$expected")
    actual=$(cat "$name")
    result="Link content: expected: $expected; actual: $actual; name: $name"
    [[ $actual = $expected ]] && okay "$result" || fail "$result"
  fi
}

main_tests () {
  local temp_dir="$APP_ROOT/_tests_$(date "+%Y%m%d_%H%M%S")"
  mkdir "$temp_dir"
  cd "$temp_dir"
  trap_term_signal_fail () {
    fail "Tests failed."
    cd ..
    rm -rf "$temp_dir"
  }
  trap trap_term_signal_fail INT TERM EXIT

  link_file_test

  trap - INT TERM EXIT
  cd ..
  rm -rf "$temp_dir"
}
