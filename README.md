# Hytale Dedicated Server

## Build

```sh
podman build --tag hytale:latest --format docker .
```

## Create container

```sh
podman create -it --name hytale-server \
    -p 5520:5520/udp \
    -v ./data:/srv/data \
    hytale:latest
```

## Start / Stop

```sh
podman start hytale-server
podman stop hytale-server
```

## Attach Server Console and Authenticate

```sh
podman attach hytale-server
```

> Use `Ctrl-p` `Ctrl-q` to detach the console without stopping the container.

Run the command below after attaching to authenticate the server. This is required for the server to be playable and must be done every time you restart it:

```sh
auth login device
```

## Logs

```sh
podman logs -f hytale-server
```

## Updating the server

```sh
podman build --tag hytale:latest --format docker .
podman stop hytale-server
podman rm hytale-server
podman create ... (same command as above)
podman start hytale-server
```

# Notes

- Port fowarding is required to the server be acessible.