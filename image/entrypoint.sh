#!/bin/bash

volume_dir="/opt/Minecraft"
server_dir="$volume_dir/servers/$SERVER_NAME"

# Install
mkdir -p "$server_dir"
cp -rf $volume_dir/image/* "$server_dir"

# Configure
echo "-Xms${SERVER_XMS} -Xmx${SERVER_XMX} ${SERVER_ARGS}" > "$user_jvm_args.txt"

# Execute
cd "$server_dir"
exec java @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.228/unix_args.txt -nogui "$@"
