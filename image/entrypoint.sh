#!/bin/bash

CFG_FILE=/opt/Terraria/serverconfig.txt

# Apply server configuration
echo "world=/opt/Terraria/worlds/${WORLD_NAME}.wld" > $CFG_FILE
echo "autocreate=${WORLD_SIZE}" >> $CFG_FILE

if [ -n "${WORLD_SEED}" ]; then
    echo "seed=${WORLD_SEED}" >> $CFG_FILE
fi

echo "worldname=${WORLD_NAME}" >> $CFG_FILE
echo "difficulty=${WORLD_DIFFICULTY}" >> $CFG_FILE
echo "maxplayers=${MAX_PLAYERS}" >> $CFG_FILE
echo "port=7777" >> $CFG_FILE

if [ -n "${PASSWORD}" ]; then
    echo "password=${PASSWORD}" >> $CFG_FILE
fi

if [ -n "${MOTD}" ]; then
    echo "motd=${MOTD}" >> $CFG_FILE
fi

echo "worldpath=/opt/Terraria/worlds" >> $CFG_FILE
echo "banlist=/opt/Terraria/banlist.txt" >> $CFG_FILE
echo "secure=${SECURE}" >> $CFG_FILE
echo "language=${SERVER_LANG}" >> $CFG_FILE
echo "upnp=${UPNP}" >> $CFG_FILE

if [ -n "${NPCSTREAM}" ]; then
    echo "npcstream=${NPCSTREAM}" >> $CFG_FILE
fi

if [ -n "${WORLD_DIFFICULTY}" ] && [ "${WORLD_DIFFICULTY}" -eq 3 ]; then
    echo "journeypermission_time_setfrozen=${JOURNEY_TIME_SETFROZEN:-2}" >> $CFG_FILE
    echo "journeypermission_time_setdawn=${JOURNEY_TIME_SETDAWN:-2}" >> $CFG_FILE
    echo "journeypermission_time_setnoon=${JOURNEY_TIME_SETNOON:-2}" >> $CFG_FILE
    echo "journeypermission_time_setdusk=${JOURNEY_TIME_SETDUSK:-2}" >> $CFG_FILE
    echo "journeypermission_time_setmidnight=${JOURNEY_TIME_SETMIDNIGHT:-2}" >> $CFG_FILE
    echo "journeypermission_godmode=${JOURNEY_GODMODE:-2}" >> $CFG_FILE
    echo "journeypermission_wind_setstrength=${JOURNEY_WIND_SETSTRENGTH:-2}" >> $CFG_FILE
    echo "journeypermission_rain_setstrength=${JOURNEY_RAIN_SETSTRENGTH:-2}" >> $CFG_FILE
    echo "journeypermission_time_setspeed=${JOURNEY_TIME_SETSPEED:-2}" >> $CFG_FILE
    echo "journeypermission_rain_setfrozen=${JOURNEY_RAIN_SETFROZEN:-2}" >> $CFG_FILE
    echo "journeypermission_wind_setfrozen=${JOURNEY_WIND_SETFROZEN:-2}" >> $CFG_FILE
    echo "journeypermission_increaseplacementrange=${JOURNEY_INCREASEPLACEMENTRANGE:-2}" >> $CFG_FILE
    echo "journeypermission_setdifficulty=${JOURNEY_SETDIFFICULTY:-2}" >> $CFG_FILE
    echo "journeypermission_biomespread_setfrozen=${JOURNEY_BIOMESPREAD_SETFROZEN:-2}" >> $CFG_FILE
    echo "journeypermission_setspawnrate=${JOURNEY_SETSPAWNRATE:-2}" >> $CFG_FILE
fi

# Execute the server
exec /opt/Terraria/server/TerrariaServer.bin.x86_64 -config $CFG_FILE
