# Don’t Starve Together Dedicated Server

## Build

```sh
podman build --tag dst:latest .
```

## Server configuration setup

1. Go to: [https://accounts.klei.com/account/game/servers?game=DontStarveTogether](https://accounts.klei.com/account/game/servers?game=DontStarveTogether)
2. Create a server and download `MyDediServer.zip`.
3. Extract it.
4. Place all extracted files into `./data/MyDediServer`.

The container expects the standard Klei layout (clusters/worlds) inside `./data/MyDediServer`.

## Create container

Bind the extracted config folder to the expected path inside the container:

```sh
podman create -ti --name dst-server \
  --mount=type=bind,src=./data/MyDediServer,dst=${HOME}/.klei/DoNotStarveTogether/ \
  localhost/dst:latest
```

`./data/MyDediServer` will contain saves, logs, and configs.

## Start / Stop

```sh
podman start dst-server
podman stop dst-server
```

## Logs

```sh
podman logs -f dst-server
```

## Updating the server

```sh
podman build --tag dst:latest .
podman stop dst-server
podman rm dst-server
podman create ... (same command as above)
podman start dst-server
```

## Notes

* Bind mounts are required to persist worlds.
* Ensure `cluster.ini`, `cluster_token.txt`, and world directories are present.
