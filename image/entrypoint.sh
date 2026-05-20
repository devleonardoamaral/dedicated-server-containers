#!/bin/bash

image_dir="/opt/Minecraft/image"
server_dir="/opt/Minecraft/servers/${SERVER_NAME}"

mkdir -p "$server_dir"
cp -rf $image_dir/* "$server_dir"

cd "$server_dir"
exec java -Xms${JVM_XMS} -Xmx${JVM_XMX} ${JVM_ARGS} @libraries/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/unix_args.txt "$@"
