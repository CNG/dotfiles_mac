#!/bin/bash

# Import a file or directory, with history, from given Git repository into the
# repository within which this function is executed
#
# Usage: git-import path/to/repo/file/or/folder/to/import
#
# Inspiration:
# - http://blog.neutrino.es/2012/git-copy-a-file-or-directory-from-another-repository-preserving-history/
# - https://gist.github.com/voltagex/3888364
#
# Also consider:
# - http://gbayer.com/development/moving-files-from-one-git-repository-to-another-preserving-history/

set -o errexit

git-import () {

  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) != true ]]; then
    echo "Must be inside Git repository work tree where ${1##*/} is to be imported."
    return
  fi

  # Make unique temporary directory
  # https://unix.stackexchange.com/a/84980/39419
  temp=$(mktemp -d 2>/dev/null || mktemp -d -t 'temp')

  # Make patches
  (
    if [[ -d $1 ]]; then
      cd "$1"
      object=.
    else
      cd "${1%/*}"
      object=${1##*/}
    fi
    git format-patch --thread -o "$temp" --root -- "$object"
  )

  # Apply patches, try aborting on error but ignore abort errors
  git am "$temp"/*.patch || git am --abort || :

  # Delete temporary directory
  rm -rf "$temp"

}
git-import "$@"
