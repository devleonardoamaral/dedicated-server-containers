# Valheim Dedicated Server

## Build

```sh
podman build --tag valheim:latest --format docker .
```

## Server configuration setup

1. Open `./config/start_server.sh` with a text editor.
2. Edit server settings by editing the below line:

```txt
./valheim_server.x86_64 -name "My server" -port 2456 -world "Dedicated" -password "secret" -crossplay
```

Removing `-crossplay` will require container port mapping and router port forwarding.

## Create container

Bind the persistent data folder to the expected path inside the container:

```sh
podman create -ti --name valheim-server \
  --mount=type=bind,src=./data,dst=/root/.config/unity3d/IronGate/Valheim \
  localhost/valheim:latest
```

`./data` will contain saves, logs, and configs.

## Start / Stop

```sh
podman start valheim-server
podman stop valheim-server
```

## Logs

```sh
podman logs -f valheim-server
```

## Updating the server

```sh
podman build --tag valheim:latest .
podman stop valheim-server
podman rm valheim-server
# podman create ... (same command as above)
podman start valheim-server
```

## Notes

* Bind mounts are required to persist worlds and server configurations.
