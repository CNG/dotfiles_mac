#######################################
# Install fb-adb if not detected.
# Globals:
#   None
# Arguments:
#   lvl  (int) Indentation level. Default 0.
# Returns:
#   None
#######################################
install_fbadb () {
  if test ! $(which fb-adb); then
    local lvl=${1:-0} # 0 unless second param set
    info $lvl "Setting up Android SDK."
    sdkmanager ndk-bundle "platforms;android-19"
    info $lvl "Installing fb-adb."
		cd /tmp
		git clone https://github.com/facebook/fb-adb.git
		cd fb-adb
		./autogen.sh
		export ANDROID_SDK=/usr/local/share/android-sdk
		export ANDROID_NDK=$ANDROID_SDK/ndk-bundle
		mkdir build
		cd build
		../configure
		/usr/local/bin/gmake
		sudo cp -a fb-adb /usr/bin
		rm -rf /tmp/fb-adb
    okay $lvl "Done."
  fi
}

install_fbadb $lvl3
