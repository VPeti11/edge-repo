#!/bin/bash
set -e 
set -o pipefail

deps="icoextract patool python-fvs python-pathvalidate python-steamgriddb vkbasalt-cli"
package_name="lutris-git opengamepadui-bin bottles lgogdownloader gzdoom yay-bin"
repo_name="edge-repo"
arch="x86_64"

if [ -e "/usr/bin/yay" ]; then
    echo "Found Yay"
else
    echo "Yay is needed to run this script!"
    exit 1
fi

for pkg in $deps; do
    yay --builddir "$(pwd)" -S "$pkg" --noconfirm
done

for pkg in $package_name; do
    yay --builddir "$(pwd)" -S "$pkg" --noconfirm
done

find . -type f -name "*debug*" -delete

mkdir -p "$repo_name"
mkdir -p "$repo_name"/"$arch"

find . -type f -name "*pkg.tar*" -exec cp {} "$repo_name"/"$arch" \;

cd "$repo_name"


cd "$arch"

repo-add "$repo_name".db.tar.gz *.pkg.tar.zst

unlink "$repo_name".db
unlink "$repo_name".files
mv "$repo_name".db.tar.gz "$repo_name".db
mv "$repo_name".files.tar.gz "$repo_name".files

echo "Repo created"
