# Don’t Starve Together Dedicated Server

## Build

```sh
podman build --tag dst:latest --format docker .
```

## Server configuration setup

1. Go to: [https://accounts.klei.com/account/game/servers?game=DontStarveTogether](https://accounts.klei.com/account/game/servers?game=DontStarveTogether)
2. Create a server and download `MyDediServer.zip`.
3. Extract it.
4. Place all extracted files into `./data/MyDediServer`.

The container expects the standard Klei layout (clusters/worlds) inside `./data`.

## Adding mods

To add mods to the server you need setup the files `./mods/dedicated_server_mods_setup.lua` and `./mods/modoverrides.lua`. After setup both files, copy `./mods/modoverrides.lua` to the following folders:

```sh
cp ./mods/modoverrides.lua ./data/Master
cp ./mods/modoverrides.lua ./data/Caves
```

> The build process automatically copies `./mods/dedicated_server_mods_setup.lua` into the image, so no manual placement is required.

## Create container

Bind the extracted config folder to the expected path inside the container:

```sh
podman create -ti --name dst-server \
  -v ./data:/root/.klei/DoNotStarveTogether/MyDediServer \
  localhost/dst:latest
```

> `./data` will contain saves, logs, and configs.

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

* Port fowarding isn‘t required to the server be visible publicly.
