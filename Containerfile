FROM debian:stable-slim

# Install download tools
RUN apt-get update \
    && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/*

COPY ./defaults/serverconfig.txt /root/defaults/serverconfig.txt
COPY ./scripts/bootstrap.sh /root/bootstrap.sh
RUN chmod +x /root/bootstrap.sh

ENTRYPOINT [ "/root/bootstrap.sh" ]
