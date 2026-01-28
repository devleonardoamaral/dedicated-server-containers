#!/bin/bash

set -e

INSTALL_DIR="/root/terraria"

VERSION="$1"
VERSION="${VERSION//'.'/''}"
shift

echo "BOOTSTRAP: verifying server installation ..."
if [ ! -d "$INSTALL_DIR/$VERSION" ]; then
    echo "BOOTSTRAP: dowloading dedicated server ..."
    curl -o /tmp/terraria.zip https://terraria.org/api/download/pc-dedicated-server/terraria-server-${VERSION}.zip 

    echo "BOOTSTRAP: unzipping files ..."
    unzip /tmp/terraria.zip -d "$INSTALL_DIR"

    echo "BOOTSTRAP: cleaning unnecessary files ..."
    rm -f /tmp/terraria.zip
    rm -rf "$INSTALL_DIR/$VERSION/Mac"
    rm -rf "$INSTALL_DIR/$VERSION/Windows"

    echo "BOOTSTRAP: setting executable permissions ..."
    chmod +x "$INSTALL_DIR/$VERSION/Linux/TerrariaServer.bin.x86_64"
fi

echo "BOOTSTRAP: verifying configuration file ..."
if [ ! -e "/root/config/serverconfig.txt" ]; then
    echo "BOOTSTRAP: setting default configuration ..."
    cp "/root/defaults/serverconfig.txt" "/root/config/serverconfig.txt"
fi

echo "BOOTSTRAP: starting server ..."
"$INSTALL_DIR/$VERSION/Linux/TerrariaServer.bin.x86_64" -config '/root/config/serverconfig.txt'

echo ""
echo "BOOTSTRAP: server exited with $?."
