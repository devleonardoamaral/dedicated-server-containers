FROM steamcmd/steamcmd:latest

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

RUN steamcmd +login anonymous +app_update 343050 validate +quit

COPY ./data/start_server.sh /root/start_server.sh
RUN chmod +x /root/start_server.sh

ENTRYPOINT ["/root/start_server.sh"]
