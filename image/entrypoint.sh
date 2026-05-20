#!/bin/bash

image_dir="/opt/Minecraft/image"
server_dir="/opt/Minecraft/servers/$SERVER_NAME"

# Install
mkdir -p "$server_dir"
cp -rf $image_dir/* "$server_dir"

# Execute
cd "$server_dir"
exec java -Xms${JVM_XMS} -Xmx${JVM_XMX} ${JVM_ARGS} @libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/unix_args.txt "$@"
