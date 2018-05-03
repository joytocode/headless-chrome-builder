#!/bin/bash

set -e
set -o pipefail

COMMAND=$1
START_TIME=$SECONDS

case "$COMMAND" in

fetch)
  echo "Fetching Chrome source code..."
  sudo yum update -y
  sudo yum install -y git redhat-lsb python bzip2 tar pkgconfig atk-devel alsa-lib-devel bison binutils brlapi-devel bluez-libs-devel bzip2-devel cairo-devel cups-devel dbus-devel dbus-glib-devel expat-devel fontconfig-devel freetype-devel gcc-c++ GConf2-devel glib2-devel glibc.i686 gperf glib2-devel gtk2-devel gtk3-devel java-1.*.0-openjdk-devel libatomic libcap-devel libffi-devel libgcc.i686 libgnome-keyring-devel libjpeg-devel libstdc++.i686 libX11-devel libXScrnSaver-devel libXtst-devel libxkbcommon-x11-devel ncurses-compat-libs nspr-devel nss-devel pam-devel pango-devel pciutils-devel pulseaudio-libs-devel zlib.i686 httpd mod_ssl php php-cli python-psutil wdiff --enablerepo=epel

  cd ~
  git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
  echo "export PATH=$PATH:$HOME/depot_tools" >> ~/.bash_profile
  source ~/.bash_profile

  mkdir chromium
  cd chromium

  fetch chromium
  echo "The source code is fetched."
  ;;

sync)
  TAG=$2
  echo "Syncing to tag [$TAG]..."
  source ~/.bash_profile
  cd ~/chromium/src
  git checkout tags/$TAG
  gclient sync
  echo "The source code is synced to tag [$TAG]."
  ;;

build)
  echo "Building Headless Chrome..."
  source ~/.bash_profile
  cd ~/chromium/src

  # Use /tmp instead of /dev/shm
  # https://groups.google.com/a/chromium.org/forum/#!msg/headless-dev/qqbZVZ2IwEw/CPInd55OBgAJ
  sed -i -e "s/use_dev_shm = true;/use_dev_shm = false;/g" base/files/file_util_posix.cc

  mkdir -p out/headless
  echo "import(\"//build/args/headless.gn\")" > out/headless/args.gn
  # Some faster build options
  # https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md#faster-builds
  echo "use_jumbo_build = true" >> out/headless/args.gn
  echo "enable_nacl = false" >> out/headless/args.gn
  echo "symbol_level = 0" >> out/headless/args.gn
  echo "remove_webcore_debug_symbols = true" >> out/headless/args.gn
  echo "is_debug = false" >> out/headless/args.gn
  echo "is_component_build = false" >> out/headless/args.gn

  gn gen out/headless
  ninja -C out/headless headless_shell

  echo "The output file is at ~/chromium/src/out/headless/headless_shell."
  ;;

*)
  echo "Error: command [$COMMAND] not found."
  ;;

esac

echo "Finished in $(($SECONDS - $START_TIME)) seconds."
