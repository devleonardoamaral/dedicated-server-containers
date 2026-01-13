FROM steamcmd/steamcmd:latest

# Dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

# Installation
RUN steamcmd +login anonymous +app_update 343050 validate +quit
COPY ./scripts/start_server.sh /root/start_server.sh
RUN chmod +x /root/start_server.sh

# Mods
COPY ./mods/modoverrides.lua /root/.klei/DoNotStarveTogether/MyDediServer/Master/modoverrides.lua
COPY ./mods/modoverrides.lua /root/.klei/DoNotStarveTogether/MyDediServer/Cave/modoverrides.lua
COPY ["./mods/dedicated_server_mods_setup.lua", "/root/.steam/steam/steamapps/common/Don\\'t Starve Together Dedicated Server/mods/dedicated_server_mods_setup.lua"]

ENTRYPOINT ["/root/start_server.sh"]
