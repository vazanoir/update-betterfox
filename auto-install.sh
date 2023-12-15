#! /usr/bin/env bash

firefoxInstallationPaths=(
    ~/.mozilla/firefox
    ~/.var/app/org.mozilla.firefox/.mozilla/firefox
    ~/.librewolf
    ~/.var/app/io.gitlab.librewolf-community/.librewolf
    ~/snap/firefox/common/.mozilla/firefox
)

installScript="./scripts/install.sh"
folderArg=""
foldersFoundCount=0

eval "chmod +x ${installScript}"

for folder in "${firefoxInstallationPaths[@]}"; do
    if [ -d $folder ]; then
    echo Firefox installation folder found

    folderArg=" -f $folder"
    eval ${installScript}${folderArg}   
    foldersFoundCount+=1

    fi

done

if [ $foldersFoundCount = 0 ];then
    echo No firefox folder found ;
    fi
