#!/usr/bin/env bash

FILENAME=update-better-fox.zip

(

cd $(mktemp -d) || exit 1
mkdir betterfox
cd betterfox

curl -LJo https://codeload.github.com/vazanoir/update-betterfox/zip/refs/heads/main

unzip $FILENAME

chmod +x auto-install.sh

./auto-install.sh

)
