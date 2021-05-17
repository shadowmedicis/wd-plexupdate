#!/bin/bash
# Script to automagically update Plex Media Server on Western Digital NAS (MyCloudOS)
#
# Must be run as root.
#
# @source @shadowmedicis
# @author @shadowmedicis

url_plexapi='https://plex.tv/api/downloads/5.json'

check_root() {
	if [ $EUID -ne 0 ]; then
	    echo "This script must be run as root: # sudo $0" 1>&2
	    exit 1
	fi
}

check_available_update() {
	latestversion="$(curl -s "$url_plexapi" | sed -n 's|.*"version":"\([^"]*\)-.*|\1|p')"
	currentversion="$(cat /shares/Volume_1/Nas_Prog/plexmediaserver/apkg.rc | grep "Version:" | cut -d ":" -f 2 | sed 's/^ *//g')"
	if [[ "$latestversion" > "$currentversion" ]]; then
		available='1'
		return $available
	else
		echo "No new version available."
	fi
}

check_model() {
     model="$(cat /usr/local/config/config.xml | grep '<hw_ver>' | sed -e 's/\(<[^<][^<]*>\)//g' | cut -d "." -f 1)"
     OS_majorversion="$(cat /usr/local/config/config.xml | grep '<sw_ver_1>' | sed -e 's/\(<[^<][^<]*>\)//g' | cut -d "." -f 1)"
     if [[ "$OS_majorversion" == "5" ]]; then
         osmodel=""$model"_OS5.bin"
     else
         osmodel=""$model".bin"
     fi
}

update_plex() {
    echo "New version of Plex is available. Upgrading..."
    url="$(curl -s $url_plexapi | awk -F'"' '{ for(i=1; i<=NF; i++) { if($i ~ /'^http.*"$osmodel"'/) print $i } } ')"
    wget --no-check-certificate -qq "$url" -P /shares/Volume_1/.systemfile/upload
    filename="$(echo "$url" | cut -d "/" -f 7)"
    /usr/sbin/upload_apkg -r"$filename" -d -f1 -g1
}

check_root
check_available_update
if [ $available ]; then
	check_model
	update_plex
fi

exit
