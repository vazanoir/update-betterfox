#!/usr/bin/env bash

SCRIPTDIRECTORY=$(cd "$(dirname $0)" && pwd)
FIREFOXFOLDER=~/.mozilla/firefox
PROFILENAME=""
USERJS=$(curl -s -o- https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js)


# Get options.
while getopts 'f:p:t:' flag; do
	case "${flag}" in
	f) FIREFOXFOLDER="${OPTARG}" ;;
	p) PROFILENAME="${OPTARG}" ;;
	*)
		echo "Update Betterfox Script:"
		echo "  -f <firefox_folder_path>. Set custom Firefox folder path."
		echo "  -p <profile_name>. Set custom profile name."
		echo "  -h to show this message."
		exit 0
		;;
	esac
done

function saveProfile(){
	local PROFILE_PATH="$1"

	cd "$FIREFOXFOLDER/$PROFILE_PATH" || { echo "FAIL, Firefox profile path was not found."; exit 1; }
	# Create a chrome directory if it doesn't exist.

	echo "Set configuration to user.js file" >&2

	if [ ! -f "user.js" ]; then
		echo -e "${USERJS}" > user.js
	else
		cp user.js user.js.bak
		echo -e "${USERJS}" > user.js
	fi
	
	echo -e $(cat "$SCRIPTDIRECTORY/user-override.js")
	echo -e $(cat $SCRIPTDIRECTORY/user-override.js) >> user.js
	
	echo "Done." >&2
	cd ..
}

PROFILES_FILE="${FIREFOXFOLDER}/profiles.ini"
if [ ! -f "${PROFILES_FILE}" ]; then
	>&2 echo "FAIL, please check Firefox installation, unable to find 'profile.ini' at ${FIREFOXFOLDER}."
	exit 1
fi
echo "'profiles.ini' found in ${FIREFOXFOLDER}"

PROFILES_PATHS=($(grep -E "^Path=" "${PROFILES_FILE}" | tr -d '\n' | sed -e 's/\s\+/SPACECHARACTER/g' | sed 's/Path=/::/g' ))
PROFILES_PATHS+=::

PROFILES_ARRAY=()
if [ "${PROFILENAME}" != "" ];
	then
		echo "Using ${PROFILENAME} profile"
		PROFILES_ARRAY+=${PROFILENAME}
else
	echo "Finding all available profiles";
	while [[ "$PROFILES_PATHS" ]]; do
		PROFILES_ARRAY+=( "${PROFILES_PATHS%%::*}" )
		PROFILES_PATHS=${PROFILES_PATHS#*::}
	done
fi



if [ ${#PROFILES_ARRAY[@]} -eq 0 ]; then
	echo "FAIL, no Firefox profile found in $PROFILES_FILE".;

else
	for i in "${PROFILES_ARRAY[@]}"
	do
		if [[ -n "$i" ]];
		then
			echo "Installing Betterfox for $(sed 's/SPACECHARACTER/ /g' <<< $i) profile.";
			saveProfile "$(sed 's/SPACECHARACTER/ /g' <<< $i)"
		fi;
	done
fi
