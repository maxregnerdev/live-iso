#!/bin/bash

set -e

# check for root permissions
if [[ "$(id -u)" != 0 ]]; then
  echo "E: Requires root permissions" > /dev/stderr
  exit 1
fi

# get config
if [ -n "$1" ]; then
  CONFIG_FILE="$1"
else
  CONFIG_FILE="etc/terraform.conf.maxregner"
fi

BASE_DIR="$PWD"

# Check if MaxRegner config exists, otherwise create it from default
if [ ! -f "$BASE_DIR/$CONFIG_FILE" ]; then
    # Create MaxRegner-specific config
    cat > "$BASE_DIR/$CONFIG_FILE" << 'MAXCONF'
# MaxRegner OS Build Configuration

# target architecture - i386, amd64, arm64, or leave empty to use host architecture
ARCH=""

# base codename
BASECODENAME="sid"

# distribution codename
CODENAME="maxregner"

# distribution version
VERSION="1.0"

# distribution channel
CHANNEL="stable"

# distribution name
NAME="MaxRegner OS"

# mirror to fetch packages from
MIRROR_URL="https://deb.debian.org/debian/"

# suffix for generated .iso files
OUTPUT_SUFFIX="-maxregner"

# folder suffix for the package lists to use
PACKAGE_LISTS_SUFFIX="maxregner-installer"
MAXCONF
fi

source "$BASE_DIR"/"$CONFIG_FILE"

echo -e "
#----------------------#
# INSTALL DEPENDENCIES #
#----------------------#
"
apt-get update
apt-get install -y live-build gnupg2 binutils zstd ca-certificates

echo -e "
#----------------------#
# PREPARE BUILD OUTPUT #
#----------------------#
"

build () {
  BUILD_ARCH="$1"
  mkdir -p "$BASE_DIR/tmp/$BUILD_ARCH"
  cd "$BASE_DIR/tmp/$BUILD_ARCH" || exit

  # remove old configs and copy over new
  rm -rf config auto
  
  # Copy MaxRegner OS specific configs
  if [ -d "$BASE_DIR/maxregner-os/etc" ]; then
      cp -r "$BASE_DIR/maxregner-os/etc/"* .
  fi
  
  # Copy standard configs
  cp -r "$BASE_DIR"/etc/* .
  
  # Make sure conffile specified as arg has correct name
  cp -f "$BASE_DIR"/"$CONFIG_FILE" terraform.conf

  # Symlink chosen package lists to where live-build will find them
  if [ -d "package-lists.$PACKAGE_LISTS_SUFFIX" ]; then
      ln -sf "package-lists.$PACKAGE_LISTS_SUFFIX" "config/package-lists"
  else
      ln -sf "package-lists.vanilla-installer" "config/package-lists"
  fi

  # Ensure MaxRegner hooks are in the correct location
  if [ -d "config/hooks/live" ]; then
      # Hooks are already in config/hooks/live/ from the cp commands above
      # No need to create a subdirectory
      true
  fi

  echo -e "
#------------------#
# LIVE-BUILD CLEAN #
#------------------#
"
  lb clean

  echo -e "
#-------------------#
# LIVE-BUILD CONFIG #
#-------------------#
"
  lb config

  echo -e "
#------------------#
# LIVE-BUILD BUILD #
#------------------#
"
  MKSQUASHFS_OPTIONS="-b 1048576" lb build

  echo -e "
#---------------------------#
# MOVE OUTPUT TO BUILDS DIR #
#---------------------------#
"
  YYYYMMDD="$(date +%Y%m%d)"
  OUTPUT_DIR="$BASE_DIR/builds/$BUILD_ARCH"
  mkdir -p "$OUTPUT_DIR"
  FNAME="${NAME:-MaxRegner-OS}-${VERSION:-1.0}-${CHANNEL:-stable}-$BUILD_ARCH.$YYYYMMDD${OUTPUT_SUFFIX:-}"
  mv $BASE_DIR/tmp/$BUILD_ARCH/live-image-$BUILD_ARCH.hybrid.iso "$OUTPUT_DIR/${FNAME}.iso"

  # cd into output to so {FNAME}.sha256.txt only
  # includes the filename and not the path to
  # our file.
  cd $OUTPUT_DIR
  md5sum "${FNAME}.iso" > "${FNAME}.md5.txt"
  sha256sum "${FNAME}.iso" > "${FNAME}.sha256.txt"
  cd $BASE_DIR
}

if [[ -z "$ARCH" ]]; then
    build "$(dpkg --print-architecture)"
else
    build "$ARCH"
fi
