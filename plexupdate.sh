#!/bin/bash
# Script to automagically update Plex Media Server on Western Digital NAS (MyCloudOS)
#
# Must be run as root.
#
# @source @shadowmedicis
# @author @shadowmedicis

url_plexapi="https://plex.tv/api/downloads/5.json"

newversion=$(curl -s "$url_plexapi" | sed -n 's|.*"version":"\([^"]*\)-.*|\1|p')
echo "Latest version: "$newversion""
curversion=$(cat /shares/Volume_1/Nas_Prog/plexmediaserver/apkg.rc | grep "Version:" | cut -d ":" -f 2 | sed 's/^ *//g')
echo "Current version: "$curversion""
if [[ "$newversion" > "$curversion" ]]
    then
    echo "Updated Version of Plex is available. Starting download & install."

    model=$(cat /usr/local/config/config.xml | grep "<hw_ver>" | sed -e 's/\(<[^<][^<]*>\)//g' | cut -d "." -f 1)
    OS_majorversion=$(cat /usr/local/config/config.xml | grep "<sw_ver_1>" | sed -e 's/\(<[^<][^<]*>\)//g' | cut -d "." -f 1)

    if [["OS_majorversion" = "5" ]]
	then
	osmodel=""$model"_OS5.bin"
		
    else
	osmodel=""$model".bin"
    fi

    url=$(curl -s "$url_plexapi" | python3 -m json.tool | grep "$osmodel" | cut -d '"' -f 4)
    wget --no-check-certificate "$url" -P /shares/Volume_1/.systemfile/upload

    filename=$(echo "$url" | cut -d "/" -f 7)
    /usr/sbin/upload_apkg -r"$filename" -d -f1 -g1
else
    echo "No new version available"
fi
exit
