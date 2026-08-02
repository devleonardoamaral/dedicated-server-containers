#!/usr/bin/env bash

set -euo pipefail

INSTDIR="/root/.local/share/Steam/steamapps/common/Project Zomboid Dedicated Server"
cd "${INSTDIR}"

cat <<EOF >"./ProjectZomboid64.json"
{
    "mainClass": "zombie/network/GameServer",
    "classpath": [
        "java/.",
        "java/projectzomboid.jar"
    ],
    "vmArgs": [
        "-Djava.awt.headless=true",
        "-Xms${JVM_XMS:-8g}",
        "-Xmx${JVM_XMX:-8g}",
        "-Dzomboid.steam=1",
        "-Dzomboid.znetlog=1",
        "-Djava.library.path=linux64/:natives/",
        "-Djava.security.egd=file:/dev/urandom",
        "-XX:+UseZGC",
        "-XX:-OmitStackTraceInFastThrow"
    ]
}
EOF

cat <<EOF >"./ProjectZomboid32.json"
{
    "mainClass": "zombie/network/GameServer",
    "classpath": [
        "java/.",
        "java/projectzomboid.jar"
    ],
    "vmArgs": [
        "-Djava.awt.headless=true",
        "-Xms${JVM_XMS:-768m}",
        "-Xmx${JVM_XMX:-768m}",
        "-Dzomboid.steam=1",
        "-Dzomboid.znetlog=1",
        "-Djava.library.path=linux32/:natives/",
        "-Djava.security.egd=file:/dev/urandom",
        "-XX:+UseG1GC",
        "-XX:-OmitStackTraceInFastThrow"
    ]
}
EOF

cat <<EOF >"./start-server.sh"
#!/usr/bin/env bash

set -eo pipefail

if "./jre64/bin/java" -version >/dev/null 2>&1; then
	echo "START-SCRIPT: 64-bit java detected"
	export PATH="${INSTDIR}/jre64/bin:\$PATH"
	export LD_LIBRARY_PATH="${INSTDIR}/jre64/lib:${INSTDIR}/linux64:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:\${LD_LIBRARY_PATH}"
	JSIG="libjsig.so"
	LD_PRELOAD="\${LD_PRELOAD}:\${JSIG}" "./ProjectZomboid64" "\$@"
elif "./jre/bin/java" -client -version >/dev/null 2>&1; then
	echo "START-SCRIPT: 32-bit java detected"
	export PATH="${INSTDIR}/jre/bin:\$PATH"
	export LD_LIBRARY_PATH="${INSTDIR}/linux32:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre/lib/i386:\${LD_LIBRARY_PATH}"
	JSIG="libjsig.so"
	LD_PRELOAD="\${LD_PRELOAD}:\${JSIG}" "./ProjectZomboid32" "\$@"
else
	echo "START-SCRIPT: couldn't determine 32/64 bit of java"
fi
EOF

sed -i "s/^RCONPassword=.*$/RCONPassword=$SERVER_RCON_PASSWORD/" "/root/Zomboid/Server/${SERVER_NAME}.ini"
sed -i "s/^DiscordEnable=.*$/DiscordEnable=$DISCORD_ENABLE/" "/root/Zomboid/Server/${SERVER_NAME}.ini"
sed -i "s/^DiscordToken=.*$/DiscordToken=$DISCORD_TOKEN/" "/root/Zomboid/Server/${SERVER_NAME}.ini"
sed -i "s/^DiscordChatChannel=.*$/DiscordChatChannel=$DISCORD_CHANNEL_CHAT_NAME/" "/root/Zomboid/Server/${SERVER_NAME}.ini"
sed -i "s/^DiscordLogChannel=.*$/DiscordLogChannel=$DISCORD_CHANNEL_LOG_NAME/" "/root/Zomboid/Server/${SERVER_NAME}.ini"
sed -i "s/^DiscordCommandChannel=.*$/DiscordCommandChannel=$DISCORD_CHANNEL_CMD_NAME/" "/root/Zomboid/Server/${SERVER_NAME}.ini"

ARGS="-servername ${SERVER_NAME:-servertest}"

if [ -n "$ADMIN_PASSWORD" ]; then
	ARGS="$ARGS -adminpassword $ADMIN_PASSWORD"
fi

if [ -n "$ADMIN_USERNAME" ]; then
	ARGS="$ARGS -adminusername $ADMIN_USERNAME"
fi

echo "ENTRYPOINT: Using args '$ARGS'"

ZOMBOID_STDIN_PIPE="/tmp/zomboid_stdin_pipe"
mkfifo "$ZOMBOID_STDIN_PIPE"

bash "$INSTDIR/start-server.sh" $ARGS 0<>"$ZOMBOID_STDIN_PIPE" &
SERVER_PID=$!
echo "ENTRYPOINT: The PID of the server is $SERVER_PID!"

QUIT=0
trap "QUIT=1" TERM INT

while [ "$QUIT" -eq "0" ] && kill -0 "$SERVER_PID" &>/dev/null; do
	sleep 5

	if read -t 0; then
		echo "STDIN: Found stdin, writing to pipe"

		while read -r -t 0.5 line; do
			echo "STDIN: Writing '$line'"
			echo "$line" >"$ZOMBOID_STDIN_PIPE"
		done
	fi
done

if kill -0 "$SERVER_PID" &>/dev/null; then
	echo "ENTRYPOINT: Received shutdown signal. Shutting down..."
	echo "ENTRYPOINT: Executing 'quit' command..."
	echo "quit" >"$ZOMBOID_STDIN_PIPE"

	echo "ENTRYPOINT: Waiting for child processes..."
	wait

	rm "$ZOMBOID_STDIN_PIPE"
	echo "ENTRYPOINT: gracefully shutdown"
	exit 0
else
	rm "$ZOMBOID_STDIN_PIPE"
	echo "ENTRYPOINT: Server process not found. Shutting down..."
	exit 1
fi
