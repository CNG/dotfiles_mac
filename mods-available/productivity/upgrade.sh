loginitems -a 'RescueTime' -s false
loginitems -a 'Scroll Reverser'
loginitems -a "Retina DisplayMenu" -p "/Applications/RDM.app"
loginitems -a "Divvy"
loginitems -a 'Clipboard History' -s false

pip_install_upgrade () {
  local pip upgrade
  pip=$(type pip3 | tail -n 1 | cut -d' ' -f3) ||
    pip=$(type pip | tail -n 1 | cut -d' ' -f3) ||
    return 1
  [[ ! $($pip list --format=legacy | grep -F "$1" > /dev/null) ]] || upgrade='--upgrade'
  $pip install "$1" $upgrade
}

pip_install_upgrade 'instagram-scraper'
