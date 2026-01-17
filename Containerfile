FROM steamcmd/steamcmd:latest

# Dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

# Installation
COPY ./scripts/bootstrap.sh /root/bootstrap.sh
RUN chmod +x /root/bootstrap.sh
COPY ./scripts/start_server.sh /root/start_server.sh
RUN chmod +x /root/start_server.sh

# Default mod files
RUN mkdir /root/mods
COPY ./mods/modoverrides.lua /root/mods/
COPY ./mods/modoverrides.lua /root/mods/
COPY ./mods/dedicated_server_mods_setup.lua /root/mods/

WORKDIR /root/

ENTRYPOINT ["/root/bootstrap.sh"]
CMD ["/root/start_server.sh"]
