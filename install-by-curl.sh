#!/usr/bin/env bash

FOLDERNAME=update-betterfox-main
FILENAME=$FOLDERNAME.zip

(

cd $(mktemp -d) || exit 1
mkdir betterfox
cd betterfox

curl -LJo $FILENAME https://codeload.github.com/vazanoir/update-betterfox/zip/refs/heads/main

unzip $FILENAME
cd $FOLDERNAME

chmod +x ./auto-install.sh

./auto-install.sh

)
