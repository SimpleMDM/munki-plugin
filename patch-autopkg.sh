#!/usr/bin/env bash
set -eu 
# This script installs and patches autopkg 2.2 with unreleased changes needed to work with the SimpleMDM Repo Plugin
# The changes are derived from this commit:
# https://github.com/autopkg/autopkg/commit/af858c033643089b8ecbccf0a8ad691d4c28a289

if [ "$(id -u)" != 0 ]; then
    echo "Error: Run this as the root user" >&2
    exit 1
fi

if ! which -s /usr/local/bin/autopkg; then
  release_path="https://github.com/autopkg/autopkg/releases/download/v2.2/autopkg-2.2.pkg"
  pkg_name=$(basename $release_path)
  pkg_tmp_path="/tmp/$pkg_name"
  echo "Downloading and installing $pkg_name" >&2
  curl -L -o "$pkg_tmp_path" $release_path;
  installer -pkg "$pkg_tmp_path" -target /
  rm "$pkg_tmp_path"
fi

autopkg_repo_path="/tmp/autopkg"
git clone https://github.com/autopkg/autopkg.git "$autopkg_repo_path"

cp -v "${autopkg_repo_path}/Code/autopkglib/MunkiImporter.py" /Library/AutoPkg/autopkglib/MunkiImporter.py
cp -v "${autopkg_repo_path}/Code/autopkglib/munkirepolibs/AutoPkgLib.py" /Library/AutoPkg/autopkglib/munkirepolibs/AutoPkgLib.py
cp -v "${autopkg_repo_path}/Code/autopkglib/munkirepolibs/AutoPkgLib.py" /Library/AutoPkg/autopkglib/munkirepolibs/AutoPkgLib.py
# this one is renamed MunkiLibAdapter.py
cp -v "${autopkg_repo_path}/Code/autopkglib/munkirepolibs/MunkiLib.py" /Library/AutoPkg/autopkglib/munkirepolibs/MunkiLibAdapter.py

rm -rf "$autopkg_repo_path"
