FROM steamcmd/steamcmd:latest

COPY ./defaults/servertest.db /root/defaults/servertest.db
COPY ./defaults/servertest.ini /root/defaults/servertest.ini

COPY ./scripts/bootstrap.sh /root/bootstrap.sh
RUN chmod +x /root/bootstrap.sh

WORKDIR "/srv/ProjectZomboidServer/"

ENTRYPOINT [ "/root/bootstrap.sh" ]
CMD [ "/srv/ProjectZomboidServer/start-server.sh" ]
