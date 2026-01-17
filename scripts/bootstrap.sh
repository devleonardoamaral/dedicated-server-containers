#!/bin/sh

set -e

VOLUME="/root/.klei/DoNotStarveTogether/MyDediServer"
INSTALL="/root/.steam/steam/steamapps/common/Don't Starve Together Dedicated Server"

install() {
    if [ ! -e "$VOLUME/dedicated_server_mods_setup.lua" ]; then
        cp "/root/mods/dedicated_server_mods_setup.lua" "$VOLUME/"
    fi
    if [ ! -e "$VOLUME/Master/modoverrides.lua" ]; then
        cp "/root/mods/modoverrides.lua" "$VOLUME/Master/"
    fi
    if [ ! -e "$VOLUME/Caves/modoverrides.lua" ]; then
        cp "/root/mods/modoverrides.lua" "$VOLUME/Caves/"
    fi
    steamcmd +login anonymous +app_update 343050 validate +quit
    cp "$VOLUME/dedicated_server_mods_setup.lua" "$INSTALL/mods/dedicated_server_mods_setup.lua"
}

install

$@
