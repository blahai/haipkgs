#!/usr/bin/env bash
set -o pipefail

PKGNAME=Vesktop

REPO="https://github.com/Vencord/Vesktop.git"
mapfile -t output < <(nix-prefetch-git --quiet "$REPO" | jq -r '.rev, .hash')
REV="${output[0]}"
HASH="${output[1]}"


get_pkgver() {
  git clone "$REPO"
  cd "$PKGNAME"
  PKGVER=$(git describe --long --tags --abbrev=7 --exclude='*[a-zA-Z][a-zA-Z]*' \
    | sed -E 's/^[^0-9]*//;s/([^-]*-g)/r\1/;s/-/./g')
  cd ..
  rm -rf "$PKGNAME"
}

get_pkgver

sed -i "s|rev = \".*\";|rev = \"$REV\";|" default.nix
sed -i "0,/hash = \".*\";/s|hash = \".*\";|hash = \"$HASH\";|" default.nix
sed -i "0,/version = \".*\";/s|version = \".*\";|version = \"$PKGVER\";|" default.nix

echo "Updated to latest commit: $REV with sha256: $HASH"
echo "$PKGVER"
