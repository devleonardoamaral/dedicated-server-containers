#!/bin/bash

cd /srv/server
cp -f /tmp/papermc.jar /srv/server/papermc.jar
echo "eula=true" > eula.txt
exec java -jar /srv/server/papermc.jar
