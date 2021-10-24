#!/bin/sh

QUERY=$(echo | dmenu -i -p "What you want to download?")
echo $QUERY
if [$QUERY -eq ""]; then
        echo "You need to write something..." | dmenu -p "Choose the torrent:"
        exit
fi
SITE=$(curl "https://thepiratebay10.org/s/?page=0&orderby=0&q=$QUERY"|  recode html..UTF-8)
echo $SITE
TORRENTS=$(echo "$SITE" | grep -oh "<a href=\"https://thepiratebay10.org/torrent/[0-9]\{8\}/.*\" class=\"detLink\" title=\"Details for .*\">.*</a>" | sed 's/<\/a>/<\/a>\n/g')
NAMES=$(echo "$TORRENTS" | grep -oh "\">.*</a>" | cut -c3- | rev | cut -c5- | rev)
if [ -z $NAMES ]; then
        echo "Nothing found or site doesn't work..." | dmenu -p "Choose the torrent:"
else
        NAME=$(echo -e "$NAMES" | dmenu -p "Choose the torrent:" | sed "s/\s/+/g;s/!/%21/g;s/#/%23/g;s/&/%26amp/g;s/'/%27/g;s/(/%28/g;s/)/%29/g")
        echo $NAME
        MAGNET=$(echo "$SITE" | grep -oh "magnet.*$NAME.*announce\" title" | rev | cut -c8- | rev)
        echo $MAGNET
        xdg-open $MAGNET
fi
