#!/bin/bash

set -eo pipefail

export templdpath="${LD_LIBRARY_PATH:-}"
export LD_LIBRARY_PATH="./linux64:${LD_LIBRARY_PATH:-}"

export SteamAppId=892970

ARGS=(
    -port 2456
)

ARGS+=(-name)
if [[ -n "${SERVER_NAME:-}" ]]; then
    ARGS+=("$SERVER_NAME")
else
    ARGS+=("myserver")
fi

ARGS+=(-password)
if [[ -n "${PASSWORD:-}" ]]; then
    ARGS+=("$PASSWORD")
else
    ARGS+=("password")
fi

ARGS+=(-world)
if [[ -n "${WORLD_NAME:-}" ]]; then
    ARGS+=("$WORLD_NAME")
else
    ARGS+=("myworld")
fi

if [[ "${CROSSPLAY:-false}" == "true" ]]; then
    ARGS+=(-crossplay)
fi

if [[ "${PUBLIC:-false}" == "true" ]]; then
    ARGS+=(-public 1)
else
    ARGS+=(-public 0)
fi

if [[ -n "${SAVEINTERVAL:-}" ]]; then
    ARGS+=(-saveinterval "$SAVEINTERVAL")
fi

if [[ -n "${BACKUPS:-}" ]]; then
    ARGS+=(-backups "$BACKUPS")
fi

if [[ -n "${BACKUPSHORT:-}" ]]; then
    ARGS+=(-backupshort "$BACKUPSHORT")
fi

if [[ -n "${BACKUPLONG:-}" ]]; then
    ARGS+=(-backuplong "$BACKUPLONG")
fi

if [[ -n "${INSTANCEID:-}" ]]; then
    ARGS+=(-instanceid "$INSTANCEID")
fi

if [[ -n "${PRESET:-}" ]]; then
    ARGS+=(-preset)
    ARGS+=("\"$PRESET\"")
fi

if [[ -n "${MODIFIERS:-}" ]]; then
    IFS=';' read -ra modifiers <<<"$MODIFIERS"

    ARGS+=("-modifier")

    for m in "${modifiers[@]}"; do
        [[ -n "$m" ]] && ARGS+=("$m")
    done
fi

if [[ -n "${SETKEYS:-}" ]]; then
    IFS=';' read -ra keys <<<"$SETKEYS"

    ARGS+=("-setkey")

    for k in "${keys[@]}"; do
        [[ -n "$k" ]] && ARGS+=("$k")
    done
fi

echo "Starting server. Press CTRL-C to exit"
printf 'Command:'
printf ' %q' ./valheim_server.x86_64 "${ARGS[@]}"
printf '\n'

# Tip: Make a local copy of this script to avoid it being overwritten by Steam.
# NOTE: Minimum password length is 5 characters & password can't be in the server name.
# NOTE: You need to make sure ports 2456-2458 are being forwarded to your server
# through your local router and firewall.

exec ./valheim_server.x86_64 "${ARGS[@]}"

export LD_LIBRARY_PATH="$templdpath"
