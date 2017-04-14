# To be sourced within dotfiles script.

MODS_ON=$APP_ROOT/mods-enabled
MODS_ALL=$APP_ROOT/mods-available
readonly APP_ROOT MODS_ON MODS_ALL

# Exit if any command returns nonzero or unset variable referenced.
set -o errexit -o pipefail -o nounset

# Allow aliases for functions in this script, such as 'alias info'.
shopt -s expand_aliases

# Make patterns that match nothing disappear instead of treated as string
# Alternative is put just inside for loop: [[ -f $file ]] || continue
shopt -s nullglob

print_usage () {
  echo "Usage: $0 $(fmt under '<command>') [$(fmt under '<args>')]

    $(fmt bold 'install')   [ $(fmt bold '--force') ] [ $(fmt under 'module') $(fmt under '...') | $(fmt bold '--all') ]
              Install required module $(fmt bold base), $(fmt under 'module') $(fmt under '...') or all available modules.
              Modules following $(fmt bold '--force') will be reinstalled.

    $(fmt bold 'upgrade')   [ $(fmt under 'module') $(fmt under '...') ]
              Upgrade all installed modules or $(fmt under 'module') $(fmt under '...').

    $(fmt bold 'remove')    [ $(fmt bold '--force') ] $(fmt under 'module') $(fmt under '...') | $(fmt bold '--all')
              Remove $(fmt under 'module') $(fmt under '...') or all installed modules. Modules following
              $(fmt bold '--force') will be removed again.

    $(fmt bold 'cleanup')   Uninstall any installed $(fmt bold 'brew') packages that are not required by
              currently installed modules. This does not run any module scripts
              or modify symbolic links but only analyzes the required package
              manifests in each installed module and removes any extras that
              were installed manually or by a module that has since changed.

    $(fmt bold 'list')      [ $(fmt bold '--installed') | $(fmt bold '--available') | $(fmt bold '--not-installed') ]
              List modules that are installed, available to install or available
              to install but not installed. If no option is specified, lists
              installed and available but not installed.

    $(fmt bold 'tests')     Run a nonexhaustive battery of internal tests.

    $(fmt bold 'help')      Show this help page.
  "
  return 1
}

#######################################
# Format text for fancy display.
# Globals:
#   None
# Arguments:
#   format  (string) Must be one of: bold, under (for underline), red, green,
#     yellow, blue, magenta, cyan, white, red, purple
#   text[]  (string) One or more texts to be concatenated and formatted
# Returns:
#   Echos string(s) wrapped in escape codes for given format
#######################################
fmt() {
  local reset=$(tput sgr0)
  local bold=$(tput bold)
  local under=$(tput smul)
  local red=$(tput setaf 1)
  local green=$(tput setaf 2)
  local yellow=$(tput setaf 3)
  local blue=$(tput setaf 4)
  local magenta=$(tput setaf 5)
  local cyan=$(tput setaf 6)
  local white=$(tput setaf 7)
  local red=$(tput setaf 9)
  local purple=$(tput setaf 13)
  echo "${!1}${@:2}${reset}"
}

#######################################
# Print wrappers for customized status output.
# Inspired by similar in @holman/dotfiles
# Globals:
#   fmt  (function) Text formatting
# Arguments:
#   type   (string) Notice type: (i|info)|(u|user)|(o|okay)|(f|fail)
#   level  (int) Indentation level. Default 0.. Defaults to 0.
#   text   (string) Text to be wrapped
# Returns:
#   Prints given text prepended by 'info', ' >> ', 'pass' or 'FAIL'
#######################################
print_wrap () {
  local color= text=
  local indent_text='| '
  local indent
  case $1 in
    i | info ) color=blue    text='info' ;;
    u | user ) color=magenta text=' >> ' ;;
    o | okay ) color=green   text='pass' ;;
    f | fail ) color=red     text='FAIL' ;;
    * ) return 1 ;;
  esac
  shift
  if [[ ${1:-0} =~ ^[0-9]+$ ]]; then
    local repeat_times=${1:-0}
    local i
    for (( i=1; i<=$repeat_times; i++)); do
      indent=$indent$indent_text
    done
    shift
  fi
  printf " %b" "\r  [$(fmt $color "$text")] $indent$@\n"
}
alias info='print_wrap i'
alias user='print_wrap u'
alias okay='print_wrap o'
alias fail='print_wrap f'

#######################################
# Try to put file or directory in trash, otherwise delete.
# Globals:
#   None
# Arguments:
#   item  (string) File or directory to trash
#   lvl   (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
trash_file () {
  local item=$1
  local lvl=${2:-0} # 0 unless second param set
  [[ -d $item || -f $item ]] || return 1
  info $lvl "Trashing $(fmt bold $item)."
  if test ! $(which trash); then
    if brew install trash; then
      if ! trash "$item"; then
        fail $lvl "Failed to trash $(fmt bold $item)."
        brew uninstall trash
        return 1
      fi
    else
      info $lvl "Unable to install trash. Deleting $(fmt bold $item)."
      rm -rf "$item"
    fi
  else
    if ! trash "$item"; then
      fail $lvl "Failed to trash $(fmt bold $item)."
      return 1
    fi
  fi
}

#######################################
# Install a module.
# Globals:
#   MODS_ALL (string) Path to all modules that can be installed.
#   MODS_ON  (string) Path to symlinks indicating installed modules.
# Arguments:
#   force   (true|false) Reinstall or error if installed.
#   module  (string) Name of module
#   lvl     (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
module_install () {
  local force=$1
  local module=$2
  local lvl=${3:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local nice_name=$(fmt bold $module)

  # If --all flag, recurse
  if [[ $module == --all ]]; then
    info $lvl "Installing all available modules."
    module_install "$force" base $lvl2
    for module in "$MODS_ALL"/*; do
      [[ ${module##*/} = base ]] && continue
      module_install "$force" "${module##*/}" $lvl2
    done
    okay $lvl "Done."
    return 0
  fi

  if [[ ! -d "$MODS_ALL/$module" ]]; then
    if [[ -h "$MODS_ON/$module" ]]; then
      info $lvl "Module $nice_name is already installed," \
        "but it cannot be reinstalled because it is unavailable."
    else
      fail $lvl "Cannot find module $nice_name."
    fi
    return 1
  fi

  if [[ -h "$MODS_ON/$module" ]]; then
    if [[ $force = true ]]; then
      info $lvl "Module $nice_name is already installed. Forcing reinstallation."
      _module_install_inner
    else
      user $lvl "Module $nice_name is already installed. To reinstall:" \
        "$(fmt bold dotfiles install --force \"$module\")"
      return 1
    fi
  else

    info $lvl "Installing module $nice_name."
    trap_term_signal () {
      fail $lvl2 "Termination signal received. Uninstalling."
      module_remove "$module" $lvl2
      rm -f "$MODS_ON/$module"
      exit
    }
    trap_fail () {
      user $lvl2 "Installation failed. Fix problem and repeat:" \
        "$(fmt bold dotfiles install \"$module\")"
      rm -f "$MODS_ON/$module"
      exit
    }
    trap trap_term_signal INT TERM
    trap trap_fail EXIT
    _module_install_inner
    trap - INT TERM EXIT

  fi
  okay $lvl "Done."
}
_module_install_inner () {
  local pth=$MODS_ON/$module
  link_file "../${MODS_ALL##*/}/$module" "$MODS_ON" $lvl2
  if [[ $module = base ]]; then
    scripts_execute "$pth" 'install' $lvl2
    packages_upgrade "$module" $lvl2
  else
    packages_upgrade "$module" $lvl2
    scripts_execute "$pth" 'install' $lvl2
  fi
  dotfiles_install "$pth" $lvl2
  scripts_execute "$pth" 'upgrade' $lvl2
}

#######################################
# Upgrade one or all enabled modules.
# Globals:
#   MODS_ON  (string) Path to symlinks indicating installed modules.
# Arguments:
#   module  (string) Name of module or "--all"
#   lvl     (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
module_upgrade () {
  local module=$1
  local lvl=${2:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))

  # If --all flag, recurse
  if [[ $module == --all ]]; then
    info $lvl "Upgrading all installed modules."
    for module in "$MODS_ON"/*; do
      module_upgrade "${module##*/}" $lvl2
    done
    okay $lvl "Done."
    return 0
  fi

  local count=0
  local nice_name=$(fmt bold $module)
  local path=$MODS_ON/$module

  if [[ ! -h $path ]]; then
    fail $lvl "Module $nice_name is not installed."
    return 1
  fi

  info $lvl "Upgrading module $nice_name."
  scripts_execute "$path" 'upgrade' $lvl2
  packages_upgrade "$module" $lvl2
  dotfiles_install "$path" $lvl2
  okay $lvl "Done."
}

#######################################
# Uninstall a module.
# Globals:
#   MODS_ALL  (string) Path to all modules that can be installed.
#   MODS_ON   (string) Path to symlinks indicating installed modules.
# Arguments:
#   force   (true|false) Reinstall or error if installed.
#   module  (string) Name of module
#   lvl     (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
module_remove () {
  local force=$1
  local module=$2
  local lvl=${3:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local nice_name=$(fmt bold $module)

  # If --all flag, recurse
  if [[ $module == --all ]]; then
    info $lvl "Removing all installed modules."
    for module in "$MODS_ALL"/*; do
      [[ ${module##*/} = base ]] && continue
      module_remove "$force" "${module##*/}" $lvl2
    done
    module_remove "$force" base $lvl2
    okay $lvl "Done."
    return 0
  fi

  if [[ -h "$MODS_ON/$module" ]]; then
    info $lvl "Removing module $nice_name."
    _module_remove_inner
    if [[ ! -d "$MODS_ALL/$module" ]]; then
      info $lvl2 "Module $nice_name is now removed," \
        "but it cannot be reinstalled because it is unavailable."
    fi
  else
    if [[ -d "$MODS_ALL/$module" ]]; then
      if [[ $force = true ]]; then
        info $lvl "Module $nice_name is not installed. Forcing uninstallation."
        _module_remove_inner
      else
        info $lvl "Module $nice_name is not installed. To remove again:" \
        "$(fmt bold dotfiles remove --force \"$module\")"
        return 0
      fi
    else
      info $lvl "Module $nice_name is neither installed nor available."
      return 0
    fi
  fi

  #info $lvl2 "Module $nice_name is now removed and can be reinstalled" \
  #  "with $(fmt bold dotfiles install \"$module\")."
  okay $lvl "Done."
}
_module_remove_inner () {
  dotfiles_remove "$MODS_ON/$module" $lvl2
  if [[ $module = base ]]; then
    packages_remove "$module" $lvl2
    scripts_execute "$MODS_ALL/$module" 'remove' $lvl2
  else
    scripts_execute "$MODS_ALL/$module" 'remove' $lvl2
    packages_remove "$module" $lvl2
  fi
  rm -f "$MODS_ON/$module"
}

#######################################
# List modules by status.
# Globals:
#   MODS_ALL  (string) Path to all modules that can be installed.
#   MODS_ON  (string) Path to symlinks indicating installed modules.
# Arguments:
#   status  (string) If not provided, separate lists of installed and not
#     installed modules will be printed. Options are --not-installed,
#     --installed, and --available
# Returns:
#   None
#######################################
module_list () {
  local output
  local module_available module_on module_test
  case ${1:-} in
    --installed )
      for module_on in "$MODS_ON"/*; do
        output="$output${module_on##*/} "
      done
      echo $(fmt bold $output)
      ;;
    --available )
      for module_available in "$MODS_ALL"/*; do
        output="$output${module_available##*/} "
      done
      echo $(fmt bold $output)
      ;;
    --not-installed )
      for module_available in "$MODS_ALL"/*; do
        module_test=false
        for module_on in "$MODS_ON"/*; do
          if [[ ${module_available##*/} = ${module_on##*/} ]]; then
            module_test=true
          fi
        done
        if [[ $module_test = false ]]; then
          output="$output${module_available##*/} "
        fi
      done
      echo $(fmt bold $output)
      ;;
    * )
      echo "These modules are installed:"
      for module_on in "$MODS_ON"/*; do
        output="$output${module_on##*/} "
      done
      echo $(fmt bold $output)
      output=
      echo "These modules are available but not installed:"
      for module_available in "$MODS_ALL"/*; do
        module_test=false
        for module_on in "$MODS_ON"/*; do
          if [[ ${module_available##*/} = ${module_on##*/} ]]; then
            module_test=true
          fi
        done
        if [[ $module_test = false ]]; then
          output="$output${module_available##*/} "
        fi
      done
      echo $(fmt bold $output)
      ;;
  esac
}

#######################################
# Remove Homebrew installed programs that are not in the cumulative Brewfiles.
# Globals:
#   APP_ROOT  (string) Application directory.
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
packages_cleanup () {
  local lvl=${1:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local brewcommand="find -L \"$MODS_ON\" -maxdepth 2 -name \"manifest*\" -print0 | xargs -0 cat | brew bundle cleanup --file=-"
  local result
  local action
  eval "result=\$($brewcommand)"
  if [[ $result =~ 'Would uninstall formulae' ]]; then
    info $lvl "The following Homebrew programs were manually installed:"
    result=$(echo "$result" | tail -n +2 | tr '\n' ',')
    result=${result%,}
    info $lvl "$(fmt bold ${result//,/, })"
    user $lvl "Uninstall?  $(fmt bold 'n/Y')"
    while read -n 1 action; do
      case $action in
        n ) info $lvl2 "All right, they will be left alone." break ;;
        Y )
          info $lvl2 "Uninstalling."
          eval "$brewcommand --force" > /dev/null
          if (( $? != 0 )); then
            fail $lvl2 "Error uninstalling."
            return 1
          else
            okay $lvl2 "Done."
          fi
          break
          ;;
        * )
          fail $lvl2 "$(fmt bold "$action") is not valid." \
            "Enter $(fmt bold n) or $(fmt bold Y)."
          ;;
      esac
    done
  fi
}

#######################################
# Install or upgrade any packages listed in a manifest.
# Globals:
#   MODS_ON  (string) Path to symlinks indicating installed modules
# Arguments:
#   manifest  (string) Path of manifest which need not exist
#   lvl       (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
packages_upgrade () {
  local module=$1
  local lvl=${2:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local manifest_pattern=manifest*
  local line package log log2
  info $lvl "Checking for packages to install or upgrade."
  local upgrade_manifest=$(
    find -H "$MODS_ON/$module" \
      -maxdepth 2 \
      -name "$manifest_pattern" \
      -print0 |
      xargs -0 cat |
      awk NF | # remove blank lines
      tr -s " " # squash spaces
  )
  if [[ -z $upgrade_manifest ]]; then
    info $lvl2 "Modules requires no packages."
  else

    if [[ ! -h "$MODS_ON/base" ]]; then
      fail $lvl2 "Need module $(fmt bold base) to process manifest."
      user $lvl2 "Retry after running: $(fmt bold dotfiles install base)"
      return 1
    fi

    if ! [[ $(echo "$upgrade_manifest" | brew bundle check --file=- > /dev/null) ]]; then
      _packages_upgrade_recurse
    fi

    # Run brew-cask-upgrade on casks in this module
    echo "$upgrade_manifest" | tr -d "'\"" |
    while read -r line; do
      line=${line%,*} # keep up to first comma
      case $line in
        'cask '* )
          package=${line#cask }
          if ! log=$(brew cu -y "$package"); then
            echo "$log"
            return 1
          fi
          ;;
      esac
    done

  fi
  okay $lvl "Done."
}
_packages_upgrade_recurse () {
  # avoid infinite loop
  local safety=$(( ${1:-0} + 1 ))
  (( safety <= 3 )) || return 1

  # exit if upgrade successful, inverted due to set -e
  # can output by ` | tee /dev/tty` http://stackoverflow.com/a/12451419/172602
  ! log=$(echo "$upgrade_manifest" | brew bundle --file=- | tee /dev/tty) || return 0

  # TODO: check for Casks requiring manual install
  # Example https://github.com/caskroom/homebrew-cask/issues/24227

  local lvl3=$(( lvl + 2 ))
  local fixes=0
  local p results result
  info $lvl2 "Upgrades failed. Attempting to fix."

  # fix any "already app" errors
  p='Error: It seems there is already an App at '"'"'.*?'"'"'.'
  if results=$(echo "$log" | tr '\n' '\a' | grep -oE "$p" | tr '\a' '\n'); then
    while read -r line; do
      line=${line#*already an App at \'}
      line=${line%\'.}
      trash_file "$line" $lvl3 && (( fixes++ ))
    done <<< "$results"
  fi

  # fix any "remove file" errors
  p='File: .*?\a.*? remove the file above.'
  if results=$(echo "$log" | tr '\n' '\a' | grep -oE "$p"); then
    while read -r result; do
      result=$(echo "$result" | tr '\a' '\n' | awk '$1 == "File:" {print $2}')
      trash_file "$result" $lvl3 && (( fixes++ ))
    done <<< "$results"
  fi

  if (( fixes > 0 && safety < 2)); then
    info $lvl2 "Resolved some errors. Upgrading again."
  elif (( safety < 3 )); then
    info $lvl2 "Updating package manager, then upgrading again."
    ( log=$(brew update) || echo $log )
    (( safety++ )) # avoid updating twice
  fi

  if ! _packages_upgrade_recurse $safety; then
    if (( safety == 3 )); then
      # _packages_upgrade_recurse short circuited to false, end of line
      fail $lvl2 "Could not resolve. Inspect log and resolve manually:"
      p='Error: .*?\aInstalling .*? has failed\!'
      echo "$log" | tr '\n' '\a' | grep -oE "$p" | tr '\a' '\n'
    fi
    return 1 # prop error up to outermost call!
  fi

}

#######################################
# Remove module's dependencies not depended on by other installed modules.
#
# Ignores that packages may be using varying options.
# Globals:
#   MODS_ON  (string) Path to symlinks indicating installed modules.
# Arguments:
#   module  (string) Name of module
#   lvl     (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
packages_remove () {
  local module=$1
  local lvl=${2:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local lvl3=$(( lvl + 2 ))
  local manifest_pattern=manifest*
  local line package log log2
  local mod_path="$MODS_ON/$module"
  [[ -h $mod_path ]] || mod_path="$MODS_ALL/$module" # when remove --force
  info $lvl "Checking for packages to remove."
  local remove_manifest=$(
    find -H "$mod_path" \
      -maxdepth 2 \
      -name "$manifest_pattern" \
      -print0 |
      xargs -0 cat |
      tr -d "'\"" | # hope package names don't contain quotes
      awk NF | # remove blank lines
      tr -s " " # squash spaces
  )
  if [[ -z $remove_manifest ]]; then
    info $lvl2 "Modules requires no packages."
  else
    # packages required by other installed modules
    local keep_manifest=$(
      find -L "$MODS_ON" \
        -maxdepth 2 \
        -path "*$MODS_ON/$module" -prune -o \
        -name "$manifest_pattern" \
        -print0 |
        xargs -0 cat |
        tr -d "'\"" | # hope package names don't contain quotes
        tr -s " " # squash spaces
    )
    while read -r line; do
      line=${line%,*} # keep up to first comma
      if ! [[ $(echo "$keep_manifest" | grep -E "^$line") ]]; then
        case $line in
          '#'* | '' | ' ' ) ;; # ignore comments and blank lines
          'tap '* )
            package=${line#tap }
            [[ $package != homebrew/core ]] || break
            if ! log=$(brew untap "$package"); then
              echo "$log"
              return 1
            fi
            ;;
          'brew '* )
            package=${line#brew }
            if log=$(brew ls --versions "$package"); then
              if ! log2=$(brew uninstall "$package"); then
                echo "$log2"
                return 1
              fi
            fi
            ;;
          'cask '* )
            package=${line#cask }
            # not sure why following doesn't work
            # if [[ $(brew cask ls --versions "$package" 2>&1) ]]; then
            if log=$(brew cask ls --versions "$package" 2>&1); then
              if ! log2=$(brew cask uninstall "$package"); then
                echo "$log2"
                return 1
              fi
            fi
            ;;
          'mas '*  )
            package=/Applications/${line#mas }.app
            if [[ -d $package ]]; then
              if ! log=$(trash_file "$package" $lvl2); then
                echo "$log"
                return 1
              fi
            fi
            ;;
          * )
            info $lvl2 "Unsure how to handle line:"
            info $lvl3 "$(fmt bold $line)"
            ;;
        esac
      fi
    done <<< "$remove_manifest"
  fi
  okay $lvl "Done."
}

#######################################
# Run scripts matching type and path.
# Globals:
#   None
# Arguments:
#   pth            (string) Directory to search
#   name           (string) Find scripts starting with this and ending in .bash or .sh
#   lvl            (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
scripts_execute () {
  local pth=$1
  local name=$2
  local lvl=${3:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local lvl3=$(( lvl + 3 ))
  local count=0

  if ! [[ -h $pth || -d $pth ]]; then
    fail $lvl "Invalid $allow_any_dir path $(fmt bold $pth)."
    return 1
  fi

  info $lvl "Checking for $name scripts."
  for file in "$pth/$name"*; do
    case $file in
      *.sh | *.bash )
        info $lvl2 "Executing $(fmt bold $file)."
        (( count++ ))
        source "$file"
        okay $lvl2 "Done."
        ;;
      * )
        fail $lvl2 "Found $(fmt bold $file), but scripts must" \
          "end in $(fmt bold .sh) or $(fmt bold .bash)."
        return 1
        ;;
    esac
  done
  (( count == 0 )) && info $lvl2 "No $name scripts found."
  okay $lvl "Done."
}

#######################################
# Symlink files named *.symlink to ~/.*
# Globals:
#   HOME  (string) Path to symlinks indicating installed modules.
# Arguments:
#   pth  (string) Directory to search
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
dotfiles_install () {
  local pth=$1
  local lvl=${2:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local count=0

  if [[ ! -h $pth ]]; then
    fail $lvl "Invalid path $(fmt bold $pth)."
    return 1
  fi

  info $lvl "Checking for configuration files to link."
  for src in "$pth"/*.symlink; do
    dst=$HOME/.$(basename "${src%.*}")
    link_file "$src" "$dst" $lvl2
    (( count++ ))
  done
  (( count > 0 )) || info $lvl2 "No configuration files found."
  okay $lvl "Done."
}

#######################################
# Undo dotfiles_install by removing symlinks in ~ corresponding to files
# named *.symlink
# Globals:
#   HOME   (string) Path to symlinks indicating installed modules.
#   force  (true|false) Silence path errors.
# Arguments:
#   pth  (string) Directory to search
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
dotfiles_remove () {
  local pth=$1
  local lvl=${2:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local count=0

  if [[ ! -h $pth ]]; then
    [[ $force = false ]] || return 0
    fail $lvl "Invalid path $(fmt bold $pth)."
    return 1
  fi

  info $lvl "Checking for configuration files that need links removed."
  for src in "$pth"/*.symlink; do
    dst=$HOME/.$(basename "${src%.*}")
    user $lvl "You may want to delete or modify: $dst"
    #TODO implement checking if backed up file exists and interactive mode
    (( count++ ))
  done
  (( count > 0 )) || info $lvl2 "No configuration files found."
  okay $lvl "Done."
}

#######################################
# Resolve all occurrences of .. within a string representing a path.
# resolve_parents solves by repetition, resolve_parents_r by recursion
#
# I asked about better way to do this on SO, but seems nothing simpler unless
# `readlink -m` is installed. See http://stackoverflow.com/q/43114674/172602
# Globals:
#   None
# Arguments:
#   path  (string) Path to normalize
# Returns:
#   path  (string) Normalized path
#######################################
resolve_parents () {
  local previous result=$1
  local re='[^\/]{1,}\/\.\.' && re="\/$re|$re\/"
  while [[ $result != $previous ]]; do
    previous=$result
    result=$(echo "$result" | awk 'sub(/\/'"$re"'/,"") || 1')
  done
  echo "$result"
}
resolve_parents_r () {
  local re='[^\/]{1,}\/\.\.'
  re="\/$re|$re\/"
  local result=$(echo "$1" | awk 'sub(/\/'"$re"'/,"") || 1')
  [[ $1 = $result ]] && echo "$1" || resolve_parents_r "$result"
}

#######################################
# Create symlinks and prompt on conflict to skip, overwrite or backup.
# Based on @holman/dotfiles but largely changed logic.
# Globals:
#   conflict_action  (string) Either "overwrite_all", "backup_all" or "skip_all"
# Arguments:
#   src  (file) Source file
#   dst  (file) Directory to put link
# Returns:
#   Prints actions taken.
#######################################
link_file () {
  # set global vars to defaults if not set
  conflict_action=${conflict_action:-}

  local src=$1 dst=$2
  # ensure $dst ends with target name to aid detection of existing link
  local norm_dst=$dst
  [[ -d $dst ]] && norm_dst=$dst/$(basename "$src")
  # resolve relative $src for existence test
  local norm_src=$src
  [[ $src != /* ]] && norm_src=$(resolve_parents "$norm_dst/../$src")

  local lvl=${3:-0} # 0 unless second param set
  local lvl2=$(( lvl + 1 ))
  local nicesrc=$(fmt bold $src)
  local nicedst=$(fmt bold $norm_dst)
  local user_input=

  info $lvl "Linking $(fmt bold "$(dirname "$nicedst") -> $src")."
  if ! [[ -f $norm_src || -d $norm_src || -L $norm_src ]]; then
    fail $lvl "Source file $nicesrc does not exist."
    return 1
  fi

  if [[ -f $norm_dst || -d $norm_dst || -L $norm_dst ]]; then
    if [[ $(readlink $norm_dst) = $src ]]; then
      okay $lvl "$nicedst already points to $nicesrc"
      return 0
    fi

    if [[ $conflict_action != *_all ]]; then
      user $lvl2 "File $nicedst already exists. What do you want to do?"
      user $lvl2 "[s]kip, [S]kip all," \
        '[o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all'
      read -n 1 user_input
      case $user_input in
        o ) conflict_action=overwrite ;;
        O ) conflict_action=overwrite_all ;;
        b ) conflict_action=backup ;;
        B ) conflict_action=backup_all ;;
        s ) conflict_action=skip ;;
        S ) conflict_action=skip_all ;;
        * ) ;;
      esac
    fi

    case $conflict_action in
      overwrite* )
        rm -rf "$norm_dst" &&
        info $lvl2 "Removed $nicedst."
        ;;
      backup* )
        local bck=${norm_dst}.$(date "+%Y%m%d_%H%M%S").backup
        mv "$norm_dst" "$bck" &&
        info $lvl2 "Moved $nicedst to $(fmt bold $bck)."
        ;;
      skip* )
        okay $lvl2 "Skipped $nicesrc."
        return 0
        ;;
      * ) ;;
    esac

  fi

  ln -s "$1" "$2" &&
  okay $lvl "Done."
}
