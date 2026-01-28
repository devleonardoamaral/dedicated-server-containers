# Terraria Dedicated Server

## Build Image

```bash
podman build --tag terraria:latest --format docker .
```

## Create Container

```bash
podman create -it --name terraria-server \
    -p 7777:7777/tcp \
    -v ./data/worlds/:/root/.local/share/Terraria/Worlds/:z \
    -v ./data/config/:/root/config/:z \
    terraria:latest "$GAME_VERSION"
```

## Start Container

```bash
podman start terraria-server
```

## Stop Container

Run `exit` command on server console.
