#!/usr/bin/env bash

set -eo pipefail

SERVER_PATH="/opt/Minecraft/servers/${SERVER_NAME}"

if [ ! -d "$SERVER_PATH" ]; then
    mkdir "$SERVER_PATH"
fi

cd "$SERVER_PATH"
cp -f "/tmp/papermc.jar" "$SERVER_PATH/papermc.jar"
echo "eula=true" >eula.txt
exec java -Xmx${JVM_XMX} -Xms${JVM_XMS} ${JVM_ARGS} -jar "$SERVER_PATH/papermc.jar" --nogui
