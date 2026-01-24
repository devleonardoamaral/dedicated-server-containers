# Project Zomboid Dedicated Server

## Build Image

```sh
podman build --tag zomboid:latest --format docker .
```

## Create container

```sh
podman create -it --name zomboid-server \
    -p 16261:16261/udp \
    -p 16262:16262/udp \
    -p 27015:27015/tcp \
    -v ./data/:/root/Zomboid/:z \
    zomboid:latest
```

## Start container

```sh
podman start zomboid-server
```

The administrator password is set by default to `admin`, and it is highly recommended to change in production .

The RCON password is set randomly, see the `RCONPassword` option in file `./data/Server/servertest.ini` to obtain the RCON password.

## Stop container

Send a RCON command with `quit`.

> Stopping the container with `stop` may cause unexpected behavior.

## Logs

```sh
podman logs -f zomboid-server
```

## Notes
- Port fowarding is required to the server be visible publicly.