#!/bin/bash
for pkg in ./x86_64/*.pkg.tar.zst; do
    gpg --armor --detach-sign --local-user 53407B947EBAD024A4645885A139E9B289DC7527 "$pkg"
done

cd x86_64

for file in *.asc; do
    if [ -f "$file" ]; then
        mv "$file" "${file%.asc}.sig"
    fi
done
