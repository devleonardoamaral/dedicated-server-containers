FROM steamcmd/steamcmd:latest

RUN apt-get update \
    && apt-get install -y libatomic1 libpulse-dev libpulse0 \
    && rm -rf /var/lib/apt/lists/*

RUN steamcmd +login anonymous +app_update 896660 validate +quit

COPY ["./config/start_server.sh", "/root/.steam/steam/steamapps/common/Valheim dedicated server/start_server.sh"]

RUN chmod +x "/root/.steam/steam/steamapps/common/Valheim dedicated server/start_server.sh"

WORKDIR /root/.steam/steam/steamapps/common/'Valheim dedicated server'

ENTRYPOINT ["/root/.steam/steam/steamapps/common/Valheim dedicated server/start_server.sh"]
