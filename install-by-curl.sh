#!/usr/bin/env bash

FILENAME=update-better-fox.tar.gz

(

cd $(mktemp -d) || exit 1
mkdir betterfox
cd betterfox

curl -LJo https://codeload.github.com/vazanoir/update-betterfox/zip/refs/heads/main

tar -xzf $FILENAME --strip-components=1

chmod +x auto-install.sh

./auto-install.sh

)
