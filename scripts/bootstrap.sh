#!/bin/sh
set -e

SRC="/srv/hytale/Server"
DST="/srv/data"

mkdir -p "$DST"

mv -n "$SRC"/* "$DST"/
mv -f "$SRC"/HytaleServer.jar "$DST"/

exec "$@"
